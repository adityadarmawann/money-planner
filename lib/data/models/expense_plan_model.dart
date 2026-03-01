class ExpensePlan {
  final String id;
  final String userId;
  final String title;
  final double amount;
  final DateTime plannedDate;
  final String category;
  final String paymentSource;
  final String? reminderType; // 'h-1', 'h-3', 'custom', or null
  final int? customReminderHours; // For custom reminder
  final bool isCompleted;
  final DateTime? completedAt;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  ExpensePlan({
    required this.id,
    required this.userId,
    required this.title,
    required this.amount,
    required this.plannedDate,
    required this.category,
    required this.paymentSource,
    this.reminderType,
    this.customReminderHours,
    this.isCompleted = false,
    this.completedAt,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExpensePlan.fromJson(Map<String, dynamic> json) {
    return ExpensePlan(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      amount: (json['amount'] as num).toDouble(),
      plannedDate: DateTime.parse(json['planned_date']),
      category: json['category'],
      paymentSource: json['payment_source'],
      reminderType: json['reminder_type'],
      customReminderHours: json['custom_reminder_hours'],
      isCompleted: json['is_completed'] ?? false,
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at']) : null,
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'amount': amount,
      'planned_date': plannedDate.toIso8601String(),
      'category': category,
      'payment_source': paymentSource,
      'reminder_type': reminderType,
      'custom_reminder_hours': customReminderHours,
      'is_completed': isCompleted,
      'completed_at': completedAt?.toIso8601String(),
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  ExpensePlan copyWith({
    String? id,
    String? userId,
    String? title,
    double? amount,
    DateTime? plannedDate,
    String? category,
    String? paymentSource,
    String? reminderType,
    int? customReminderHours,
    bool? isCompleted,
    DateTime? completedAt,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ExpensePlan(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      plannedDate: plannedDate ?? this.plannedDate,
      category: category ?? this.category,
      paymentSource: paymentSource ?? this.paymentSource,
      reminderType: reminderType ?? this.reminderType,
      customReminderHours: customReminderHours ?? this.customReminderHours,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// Constants untuk kategori
class ExpenseCategory {
  static const kosmetik = 'Kosmetik';
  static const makanan = 'Makanan & Minuman';
  static const elektronik = 'Alat Elektronik';
  static const pakaian = 'Pakaian';
  static const transportasi = 'Transportasi';
  static const hiburan = 'Hiburan';
  static const kesehatan = 'Kesehatan';
  static const pendidikan = 'Pendidikan';
  static const custom = 'Custom';

  static List<String> get defaults => [
    kosmetik,
    makanan,
    elektronik,
    pakaian,
    transportasi,
    hiburan,
    kesehatan,
    pendidikan,
  ];
}

// Constants untuk payment source
class PaymentSource {
  static const studentPlanWallet = 'StudentPlan Wallet';
  static const bank = 'Bank';
  static const custom = 'Custom';

  static List<String> get defaults => [studentPlanWallet, bank, custom];
}

// Constants untuk reminder
class ReminderType {
  static const h1 = 'h-1'; // 1 hari sebelomnya
  static const h3 = 'h-3'; // 3 jam sebelomnya
  static const custom = 'custom';

  static Map<String, String> get labels => {
    h1: '1 Hari Sebelumnya',
    h3: '3 Jam Sebelumnya',
    custom: 'Custom',
  };
}
