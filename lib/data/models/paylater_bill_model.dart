enum BillStatus { active, paid, overdue, cancelled }

class PaylaterBillModel {
  final String id;
  final String paylaterId;
  final String userId;
  final double principalAmount;
  final double interestAmount;
  final double totalDue;
  final int tenorMonths;
  final DateTime dueDate;
  final DateTime? paidAt;
  final BillStatus status;
  final String? transactionId;
  final DateTime createdAt;

  const PaylaterBillModel({
    required this.id,
    required this.paylaterId,
    required this.userId,
    required this.principalAmount,
    required this.interestAmount,
    required this.totalDue,
    required this.tenorMonths,
    required this.dueDate,
    this.paidAt,
    this.status = BillStatus.active,
    this.transactionId,
    required this.createdAt,
  });

  bool get isOverdue =>
      status == BillStatus.active && dueDate.isBefore(DateTime.now());

  factory PaylaterBillModel.fromJson(Map<String, dynamic> json) {
    return PaylaterBillModel(
      id: json['id'] as String,
      paylaterId: json['paylater_id'] as String,
      userId: json['user_id'] as String,
      principalAmount: (json['principal_amount'] as num).toDouble(),
      interestAmount: (json['interest_amount'] as num).toDouble(),
      totalDue: (json['total_due'] as num).toDouble(),
      tenorMonths: json['tenor_months'] as int,
      dueDate: DateTime.parse(json['due_date'] as String),
      paidAt: json['paid_at'] != null
          ? DateTime.parse(json['paid_at'] as String)
          : null,
      status: _parseStatus(json['status'] as String? ?? 'active'),
      transactionId: json['transaction_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  static BillStatus _parseStatus(String value) {
    switch (value) {
      case 'paid':
        return BillStatus.paid;
      case 'overdue':
        return BillStatus.overdue;
      case 'cancelled':
        return BillStatus.cancelled;
      default:
        return BillStatus.active;
    }
  }

  BillStatus get effectiveStatus {
    if (status == BillStatus.active && isOverdue) return BillStatus.overdue;
    return status;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'paylater_id': paylaterId,
      'user_id': userId,
      'principal_amount': principalAmount,
      'interest_amount': interestAmount,
      'total_due': totalDue,
      'tenor_months': tenorMonths,
      'due_date': dueDate.toIso8601String().split('T')[0],
      'paid_at': paidAt?.toIso8601String(),
      'status': status.name,
      'transaction_id': transactionId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
