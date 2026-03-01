import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/budget_provider.dart';
import '../../../providers/expense_plan_provider.dart';
import '../../../data/models/budget_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../widgets/common/sp_card.dart';
import '../../widgets/common/sp_loading.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  String _selectedPeriod = 'month'; // 'month', 'year', 'custom'

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _loadData() async {
    final userId = context.read<AuthProvider>().currentUser?.id;
    if (userId == null) return;
    final budgetProvider = context.read<BudgetProvider>();
    final expensePlanProvider = context.read<ExpensePlanProvider>();
    final now = DateTime.now();
    await Future.wait([
      budgetProvider.loadBudgets(userId),
      budgetProvider.loadCategories(userId: userId),
      expensePlanProvider.loadExpensePlansForMonth(userId, now.year, now.month),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BudgetProvider>();
    final expensePlanProvider = context.watch<ExpensePlanProvider>();
    final monthlyPlans = [...expensePlanProvider.expensePlans]
      ..sort((a, b) => a.plannedDate.compareTo(b.plannedDate));

    // Get current period budget
    final now = DateTime.now();
    BudgetModel? currentBudget;
    try {
      currentBudget = provider.budgets.firstWhere(
        (b) => b.startDate.isBefore(now) && b.endDate.isAfter(now),
      );
    } catch (_) {
      // If no budget found for current period, use the first one
      if (provider.budgets.isNotEmpty) {
        currentBudget = provider.budgets.first;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Anggaran Saya'),
        actions: [
          Consumer<ExpensePlanProvider>(
            builder: (context, expensePlanProvider, _) {
              final planCount = expensePlanProvider.expensePlans.length;
              return IconButton(
                tooltip: 'Rencana Pengeluaran',
                onPressed: () => Navigator.pushNamed(
                  context,
                  AppRoutes.expensePlanCalendar,
                ).then((_) => _loadData()),
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.calendar_month_rounded),
                    if (planCount > 0)
                      Positioned(
                        right: -6,
                        top: -6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Text(
                            planCount > 99 ? '99+' : '$planCount',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.budgetCreate)
                .then((_) => _loadData()),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: provider.isLoading &&
                provider.budgets.isEmpty &&
                monthlyPlans.isEmpty
            ? const SpLoading()
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Period Selection & Income/Expense Chart
                  if (currentBudget != null) ...[
                    const Text(
                      'Ringkasan Keuangan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SpCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Period Selector
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    setState(() => _selectedPeriod = 'month');
                                  },
                                  icon: const Icon(Icons.calendar_today, size: 16),
                                  label: const Text('Bulan Ini'),
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: _selectedPeriod == 'month'
                                        ? AppColors.primary.withValues(alpha: 0.1)
                                        : null,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    setState(() => _selectedPeriod = 'year');
                                  },
                                  icon: const Icon(Icons.date_range, size: 16),
                                  label: const Text('Tahunan'),
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: _selectedPeriod == 'year'
                                        ? AppColors.primary.withValues(alpha: 0.1)
                                        : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Income vs Expense Pie Chart
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      'Pemasukan vs Pengeluaran',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      height: 150,
                                      child: PieChart(
                                        PieChartData(
                                          sections: [
                                            PieChartSectionData(
                                              value: currentBudget.totalIncome > 0
                                                  ? currentBudget.totalIncome
                                                  : 1,
                                              color: AppColors.income,
                                              title: currentBudget.totalIncome > 0
                                                  ? '${((currentBudget.totalIncome / (currentBudget.totalIncome + currentBudget.totalExpense)) * 100).toStringAsFixed(0)}%'
                                                  : '0%',
                                              radius: 50,
                                              titleStyle: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            PieChartSectionData(
                                              value: currentBudget.totalExpense > 0
                                                  ? currentBudget.totalExpense
                                                  : 1,
                                              color: AppColors.expense,
                                              title: currentBudget.totalExpense > 0
                                                  ? '${((currentBudget.totalExpense / (currentBudget.totalIncome + currentBudget.totalExpense)) * 100).toStringAsFixed(0)}%'
                                                  : '0%',
                                              radius: 50,
                                              titleStyle: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                          borderData: FlBorderData(show: false),
                                          centerSpaceRadius: 0,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    // Legend
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 12,
                                              height: 12,
                                              decoration: BoxDecoration(
                                                color: AppColors.income,
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              'Pemasukan: ${CurrencyFormatter.format(currentBudget.totalIncome)}',
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 12,
                                              height: 12,
                                              decoration: BoxDecoration(
                                                color: AppColors.expense,
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              'Pengeluaran: ${CurrencyFormatter.format(currentBudget.totalExpense)}',
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (monthlyPlans.isNotEmpty) ...[
                    const Text(
                      'Rencana Pengeluaran Bulan Ini',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...monthlyPlans.map(
                      (plan) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _ExpensePlanMiniCard(
                          title: plan.title,
                          category: plan.category,
                          paymentSource: plan.paymentSource,
                          plannedDate: plan.plannedDate,
                          amount: plan.amount,
                          isCompleted: plan.isCompleted,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],
                  const Text(
                    'Daftar Anggaran',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (provider.budgets.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.pie_chart_outline,
                                size: 64, color: AppColors.textHint),
                            const SizedBox(height: 16),
                            const Text(
                              'Belum ada anggaran',
                              style: TextStyle(
                                  color: AppColors.textSecondary, fontSize: 16),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () => Navigator.pushNamed(
                                      context, AppRoutes.budgetCreate)
                                  .then((_) => _loadData()),
                              icon: const Icon(Icons.add),
                              label: const Text('Buat Anggaran'),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...provider.budgets.map(
                      (budget) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _BudgetCard(
                          budget: budget,
                          onTap: () {
                            provider.selectBudget(budget);
                            Navigator.pushNamed(
                              context,
                              AppRoutes.budgetDetail,
                              arguments: budget,
                            ).then((_) => _loadData());
                          },
                          onDelete: () => _deleteBudget(budget),
                        ),
                      ),
                    ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.pushNamed(context, AppRoutes.budgetCreate)
                .then((_) => _loadData()),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Future<void> _deleteBudget(BudgetModel budget) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Anggaran'),
        content: Text('Hapus anggaran "${budget.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await context.read<BudgetProvider>().deleteBudget(budget.id);
    }
  }
}

class _ExpensePlanMiniCard extends StatelessWidget {
  final String title;
  final String category;
  final String paymentSource;
  final DateTime plannedDate;
  final double amount;
  final bool isCompleted;

  const _ExpensePlanMiniCard({
    required this.title,
    required this.category,
    required this.paymentSource,
    required this.plannedDate,
    required this.amount,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return SpCard(
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppColors.success.withValues(alpha: 0.12)
                  : AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isCompleted ? Icons.check_rounded : Icons.schedule_rounded,
              color: isCompleted ? AppColors.success : AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${DateFormatter.formatDate(plannedDate)} • $category',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Sumber: $paymentSource',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            CurrencyFormatter.format(amount),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _BudgetCard extends StatelessWidget {
  final BudgetModel budget;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _BudgetCard({
    required this.budget,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final percent = budget.percentageUsed;
    final progressColor = percent >= 90
        ? AppColors.error
        : percent >= 70
            ? AppColors.warning
            : AppColors.success;

    return SpCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      budget.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${budget.periodTypeLabel} • ${DateFormatter.formatDate(budget.startDate)} - ${DateFormatter.formatDate(budget.endDate)}',
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline,
                    color: AppColors.error, size: 20),
                onPressed: onDelete,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Pemasukan',
                        style: TextStyle(
                            color: AppColors.textHint, fontSize: 11)),
                    Text(
                      CurrencyFormatter.format(budget.totalIncome),
                      style: const TextStyle(
                        color: AppColors.income,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Pengeluaran',
                        style: TextStyle(
                            color: AppColors.textHint, fontSize: 11)),
                    Text(
                      CurrencyFormatter.format(budget.totalExpense),
                      style: const TextStyle(
                        color: AppColors.expense,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Sisa',
                        style: TextStyle(
                            color: AppColors.textHint, fontSize: 11)),
                    Text(
                      CurrencyFormatter.format(budget.remaining),
                      style: TextStyle(
                        color: budget.remaining >= 0
                            ? AppColors.primary
                            : AppColors.error,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: percent / 100,
              backgroundColor: progressColor.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${percent.toStringAsFixed(0)}% terpakai',
            style: TextStyle(
              color: progressColor,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
