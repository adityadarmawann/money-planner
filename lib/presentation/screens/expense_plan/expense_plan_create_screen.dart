import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/expense_plan_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/expense_plan_model.dart';
import '../../widgets/common/sp_button.dart';
import '../../widgets/common/sp_text_field.dart';
import '../../widgets/common/sp_snackbar.dart';

class ExpensePlanCreateScreen extends StatefulWidget {
  final ExpensePlan? plan; // For editing
  final DateTime? initialDate; // For creating from selected calendar date

  const ExpensePlanCreateScreen({
    super.key,
    this.plan,
    this.initialDate,
  });

  @override
  State<ExpensePlanCreateScreen> createState() =>
      _ExpensePlanCreateScreenState();
}

class _ExpensePlanCreateScreenState extends State<ExpensePlanCreateScreen> {
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _notesController;
  late TextEditingController _customReminderController;

  DateTime? _selectedDate;
  String? _selectedCategory;
  String? _selectedPaymentSource;
  String? _selectedReminder;
  int? _customReminderHours;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.plan?.title ?? '');
    _amountController =
        TextEditingController(text: widget.plan?.amount.toString() ?? '');
    _notesController = TextEditingController(text: widget.plan?.notes ?? '');
    _customReminderController = TextEditingController(
        text: widget.plan?.customReminderHours?.toString() ?? '');

    _selectedDate = widget.plan?.plannedDate ?? widget.initialDate ?? DateTime.now();
    _selectedCategory = widget.plan?.category ?? ExpenseCategory.makanan;
    _selectedPaymentSource =
        widget.plan?.paymentSource ?? PaymentSource.studentPlanWallet;
    _selectedReminder = widget.plan?.reminderType;
    _customReminderHours = widget.plan?.customReminderHours;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    _customReminderController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final initialDate = _selectedDate ?? now;
    final firstDate = DateTime(now.year - 5, 1, 1);
    final lastDate = DateTime(now.year + 5, 12, 31);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      showSpSnackbar(context, 'Pilih tanggal terlebih dahulu', isError: true);
      return;
    }
    if (_selectedCategory == null) {
      showSpSnackbar(context, 'Pilih kategori terlebih dahulu', isError: true);
      return;
    }
    if (_selectedPaymentSource == null) {
      showSpSnackbar(context, 'Pilih sumber pembayaran terlebih dahulu',
          isError: true);
      return;
    }

    if (_selectedReminder == ReminderType.custom &&
        _customReminderHours == null) {
      showSpSnackbar(context, 'Input jam reminder kustom', isError: true);
      return;
    }
    if (_selectedReminder == ReminderType.custom &&
        (_customReminderHours ?? 0) <= 0) {
      showSpSnackbar(context, 'Jam reminder harus lebih dari 0', isError: true);
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final expensePlanProvider = context.read<ExpensePlanProvider>();

    if (authProvider.currentUser == null) {
      showSpSnackbar(context, 'Login terlebih dahulu', isError: true);
      return;
    }

    final parsedAmount = double.tryParse(_amountController.text.trim());
    if (parsedAmount == null) {
      showSpSnackbar(context, 'Jumlah pengeluaran tidak valid', isError: true);
      return;
    }

    bool success;
    if (widget.plan == null) {
      success = await expensePlanProvider.createExpensePlan(
        userId: authProvider.currentUser!.id,
        title: _titleController.text.trim(),
        amount: parsedAmount,
        plannedDate: _selectedDate!,
        category: _selectedCategory!,
        paymentSource: _selectedPaymentSource!,
        reminderType: _selectedReminder,
        customReminderHours: _selectedReminder == ReminderType.custom
            ? _customReminderHours
            : null,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );
    } else {
      success = await expensePlanProvider.updateExpensePlan(
        widget.plan!.id,
        {
          'title': _titleController.text.trim(),
          'amount': parsedAmount,
          'planned_date': _selectedDate!.toIso8601String().split('T')[0],
          'category': _selectedCategory!,
          'payment_source': _selectedPaymentSource!,
          'reminder_type': _selectedReminder,
          'custom_reminder_hours': _selectedReminder == ReminderType.custom
              ? _customReminderHours
              : null,
          'notes': _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        },
      );
    }

    if (!mounted) return;

    if (success) {
      final syncWarning = expensePlanProvider.syncWarningMessage;
      showSpSnackbar(
        context,
        syncWarning ??
            (widget.plan == null
                ? 'Rencana pengeluaran berhasil ditambahkan'
                : 'Rencana pengeluaran berhasil diperbarui'),
        isError: false,
      );
      Navigator.pop(context);
    } else {
      showSpSnackbar(
        context,
        expensePlanProvider.errorMessage ?? 'Terjadi kesalahan',
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<ExpensePlanProvider>().isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(widget.plan == null
            ? 'Tambah Rencana Pengeluaran'
            : 'Edit Rencana Pengeluaran'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              SpTextField(
                label: 'Nama Rencana Pengeluaran',
                hint: 'Ex: Beli sepatu baru',
                controller: _titleController,
                validator: (v) =>
                    Validators.validateRequired(v, 'Nama pengeluaran'),
              ),
              const SizedBox(height: 16),

              // Amount
              SpTextField(
                label: 'Jumlah Pengeluaran',
                hint: '0',
                controller: _amountController,
                keyboardType: TextInputType.number,
                validator: Validators.validateAmount,
                prefix: const Icon(Icons.money, color: AppColors.textHint),
              ),
              const SizedBox(height: 16),

              // Date Picker
              _buildDatePicker(),
              const SizedBox(height: 16),

              // Category
              _buildCategoryDropdown(),
              const SizedBox(height: 16),

              // Payment Source
              _buildPaymentSourceDropdown(),
              const SizedBox(height: 16),

              // Reminder
              _buildReminderSection(),
              const SizedBox(height: 16),

              // Notes
              SpTextField(
                label: 'Catatan (Opsional)',
                hint: 'Catatan tambahan...',
                controller: _notesController,
                maxLines: 3,
              ),
              const SizedBox(height: 32),

              // Submit Button
              SpButton(
                text: widget.plan == null ? 'Tambah Rencana' : 'Ubah Rencana',
                onPressed: _submit,
                isLoading: isLoading,
              ),
              const SizedBox(height: 16),

              // Delete Button (jika edit)
              if (widget.plan != null)
                SpButton(
                  text: 'Hapus Rencana',
                  onPressed: () => _showDeleteConfirmation(),
                  isOutlined: true,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: _selectDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryLightest),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tanggal Pengeluaran',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _selectedDate?.toString().split(' ')[0] ?? 'Pilih tanggal',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const Icon(Icons.calendar_today, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kategori',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryLightest),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<String>(
            value: _selectedCategory,
            isExpanded: true,
            underline: const SizedBox.shrink(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            items: [
              ...ExpenseCategory.defaults,
              ExpenseCategory.custom,
            ]
                .map((category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedCategory = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentSourceDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sumber Pembayaran',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryLightest),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<String>(
            value: _selectedPaymentSource,
            isExpanded: true,
            underline: const SizedBox.shrink(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            items: [
              ...PaymentSource.defaults,
            ]
                .map((source) => DropdownMenuItem(
                      value: source,
                      child: Text(source),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedPaymentSource = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReminderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pengingat',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryLightest),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<String>(
            value: _selectedReminder,
            isExpanded: true,
            underline: const SizedBox.shrink(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            hint: const Text('Pilih pengingat (opsional)'),
            items: [
              const DropdownMenuItem(
                value: null,
                child: Text('Tanpa pengingat'),
              ),
              DropdownMenuItem(
                value: ReminderType.h1,
                child: Text(ReminderType.labels[ReminderType.h1]!),
              ),
              DropdownMenuItem(
                value: ReminderType.h3,
                child: Text(ReminderType.labels[ReminderType.h3]!),
              ),
              DropdownMenuItem(
                value: ReminderType.custom,
                child: Text(ReminderType.labels[ReminderType.custom]!),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedReminder = value;
                if (_selectedReminder != ReminderType.custom) {
                  _customReminderHours = null;
                  _customReminderController.clear();
                }
              });
            },
          ),
        ),
        if (_selectedReminder == ReminderType.custom) ...[
          const SizedBox(height: 12),
          SpTextField(
            label: 'Jam Pengingat (sebelum pengeluaran)',
            hint: '3',
            controller: _customReminderController,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _customReminderHours = int.tryParse(value);
              });
            },
            validator: (v) {
              if (_selectedReminder == ReminderType.custom &&
                  (v == null || v.isEmpty)) {
                return 'Masukkan jam pengingat';
              }
              return null;
            },
            suffix: const Text('jam'),
          ),
        ],
      ],
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Rencana Pengeluaran?'),
        content: const Text('Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _delete();
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _delete() async {
    final expensePlanProvider = context.read<ExpensePlanProvider>();
    final success =
        await expensePlanProvider.deleteExpensePlan(widget.plan!.id);

    if (!mounted) return;

    if (success) {
      showSpSnackbar(
        context,
        'Rencana pengeluaran berhasil dihapus',
        isError: false,
      );
      Navigator.pop(context);
    } else {
      showSpSnackbar(
        context,
        expensePlanProvider.errorMessage ??
            'Gagal menghapus rencana pengeluaran',
        isError: true,
      );
    }
  }
}
