enum PaylaterStatus { active, suspended, closed }

class PaylaterAccountModel {
  final String id;
  final String userId;
  final double creditLimit;
  final double usedLimit;
  final double interestRate;
  final PaylaterStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PaylaterAccountModel({
    required this.id,
    required this.userId,
    this.creditLimit = 1000000,
    this.usedLimit = 0,
    this.interestRate = 2.5,
    this.status = PaylaterStatus.active,
    required this.createdAt,
    required this.updatedAt,
  });

  double get remainingLimit => creditLimit - usedLimit;

  double get usedPercentage =>
      creditLimit > 0 ? (usedLimit / creditLimit * 100).clamp(0, 100) : 0;

  factory PaylaterAccountModel.fromJson(Map<String, dynamic> json) {
    return PaylaterAccountModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      creditLimit: (json['credit_limit'] as num? ?? 1000000).toDouble(),
      usedLimit: (json['used_limit'] as num? ?? 0).toDouble(),
      interestRate: (json['interest_rate'] as num? ?? 2.5).toDouble(),
      status: _parseStatus(json['status'] as String? ?? 'active'),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  static PaylaterStatus _parseStatus(String value) {
    switch (value) {
      case 'suspended':
        return PaylaterStatus.suspended;
      case 'closed':
        return PaylaterStatus.closed;
      default:
        return PaylaterStatus.active;
    }
  }

  PaylaterAccountModel copyWith({
    String? id,
    String? userId,
    double? creditLimit,
    double? usedLimit,
    double? interestRate,
    PaylaterStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PaylaterAccountModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      creditLimit: creditLimit ?? this.creditLimit,
      usedLimit: usedLimit ?? this.usedLimit,
      interestRate: interestRate ?? this.interestRate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
