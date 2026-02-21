import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/budget_provider.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _loadData() async {
    final userId = context.read<AuthProvider>().currentUser?.id;
    if (userId == null) return;
    final budgetProvider = context.read<BudgetProvider>();
    await Future.wait([
      budgetProvider.loadBudgets(userId),
      budgetProvider.loadCategories(userId: userId),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BudgetProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Anggaran Saya'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.budgetCreate)
                .then((_) => _loadData()),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: provider.isLoading && provider.budgets.isEmpty
            ? const SpLoading()
            : provider.budgets.isEmpty
                ? Center(
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
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: provider.budgets.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final budget = provider.budgets[index];
                      return _BudgetCard(
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
                      );
                    },
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
              backgroundColor: progressColor.withOpacity(0.15),
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
