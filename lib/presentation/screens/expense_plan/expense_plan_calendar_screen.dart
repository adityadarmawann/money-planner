import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/expense_plan_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../widgets/common/sp_button.dart';

class ExpensePlanCalendarScreen extends StatefulWidget {
  const ExpensePlanCalendarScreen({super.key});

  @override
  State<ExpensePlanCalendarScreen> createState() =>
      _ExpensePlanCalendarScreenState();
}

class _ExpensePlanCalendarScreenState extends State<ExpensePlanCalendarScreen> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _loadExpensePlans();
  }

  void _loadExpensePlans() {
    final authProvider = context.read<AuthProvider>();
    final expensePlanProvider = context.read<ExpensePlanProvider>();

    if (authProvider.currentUser != null) {
      expensePlanProvider.loadExpensePlansForMonth(
        authProvider.currentUser!.id,
        _selectedDate.year,
        _selectedDate.month,
      );
    }
  }

  void _nextMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1);
    });
    _loadExpensePlans();
  }

  void _previousMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1);
    });
    _loadExpensePlans();
  }

  @override
  Widget build(BuildContext context) {
    final expensePlanProvider = context.watch<ExpensePlanProvider>();
    final authProvider = context.read<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Rencana Pengeluaran'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Calendar Header dengan month navigation
              _buildCalendarHeader(),
              const SizedBox(height: 24),

              // Calendar Grid
              _buildCalendarGrid(expensePlanProvider),
              const SizedBox(height: 24),

              // Summary cards
              _buildSummaryCards(expensePlanProvider, authProvider),
              const SizedBox(height: 32),

              // Expense plans untuk tanggal yang dipilih
              _buildSelectedDateExpensePlans(expensePlanProvider),
              const SizedBox(height: 32),

              // Add Button
              SpButton(
                text: 'Tambah Rencana Pengeluaran',
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.expensePlanCreate);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: _previousMonth,
          icon: const Icon(Icons.chevron_left),
          color: AppColors.primary,
        ),
        Text(
          DateFormatter.formatMonthYear(_selectedDate),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        IconButton(
          onPressed: _nextMonth,
          icon: const Icon(Icons.chevron_right),
          color: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildCalendarGrid(ExpensePlanProvider provider) {
    final firstDay = DateTime(_selectedDate.year, _selectedDate.month, 1);
    final lastDay = DateTime(_selectedDate.year, _selectedDate.month + 1, 0);
    final daysInMonth = lastDay.day;
    final startingDayOfWeek = firstDay.weekday;

    final datesWithPlans = provider.getDatesWithPlans();

    return Column(
      children: [
        // Weekday headers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab']
              .map((day) => Text(
                    day,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 12),

        // Calendar days
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: 42, // 6 weeks * 7 days
          itemBuilder: (context, index) {
            final day = index - startingDayOfWeek + 2;

            if (day < 1 || day > daysInMonth) {
              return const SizedBox.shrink();
            }

            final date = DateTime(_selectedDate.year, _selectedDate.month, day);
            final isSelected = day == _selectedDate.day;
            final hasPlans = datesWithPlans
                .any((d) => d.year == date.year && d.month == date.month && d.day == date.day);
            final isToday = DateTime.now().day == day &&
                DateTime.now().month == _selectedDate.month &&
                DateTime.now().year == _selectedDate.year;

            return InkWell(
              onTap: () {
                setState(() {
                  _selectedDate = date;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? AppColors.primary
                      : hasPlans
                          ? AppColors.primaryLightest
                          : Colors.transparent,
                  border: isToday
                      ? Border.all(color: AppColors.primary, width: 2)
                      : null,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      '$day',
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    if (hasPlans && !isSelected)
                      Positioned(
                        bottom: 4,
                        child: Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSummaryCards(
    ExpensePlanProvider provider,
    AuthProvider authProvider,
  ) {
    return FutureBuilder<double>(
      future: provider.getTotalForMonth(
        authProvider.currentUser!.id,
        _selectedDate.year,
        _selectedDate.month,
      ),
      builder: (context, snapshot) {
        final total = snapshot.data ?? 0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Summary',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total ${DateFormatter.formatMonthYear(_selectedDate)}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        CurrencyFormatter.format(total),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.calendar_month_rounded,
                    color: AppColors.primary,
                    size: 32,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSelectedDateExpensePlans(ExpensePlanProvider provider) {
    final plansForDate = provider.getExpensePlansForDate(_selectedDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rencana Pengeluaran - ${DateFormatter.formatDate(_selectedDate)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        if (plansForDate.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 48,
                    color: AppColors.textSecondary.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Tidak ada rencana pengeluaran',
                    style: TextStyle(
                      color: AppColors.textSecondary.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: plansForDate.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final plan = plansForDate[index];

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primaryLightest,
                  ),
                ),
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
                                plan.title,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                plan.category,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          CurrencyFormatter.format(plan.amount),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sumber: ${plan.paymentSource}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (plan.reminderType != null)
                          Text(
                            'Reminder: ${plan.reminderType}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.primary,
                            ),
                          ),
                      ],
                    ),
                    if (plan.notes != null && plan.notes!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        plan.notes!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}
