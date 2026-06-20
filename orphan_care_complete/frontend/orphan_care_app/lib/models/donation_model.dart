/// نموذج بيانات التبرع - يستخدم للتواصل بين التطبيق والمنظومة
class DonationModel {
  final int id;
  final String donorName;
  final String itemType;
  final String status;
  final double? amount;
  final String? description;
  final String? category;
  final DateTime? donationDate;
  final DateTime? createdAt;

  DonationModel({
    required this.id,
    required this.donorName,
    required this.itemType,
    required this.status,
    this.amount,
    this.description,
    this.category,
    this.donationDate,
    this.createdAt,
  });

  /// تحويل من JSON إلى نموذج
  factory DonationModel.fromJson(Map<String, dynamic> json) {
    return DonationModel(
      id: json['id'] ?? 0,
      donorName: json['donor_name'] ?? json['donor'] ?? '',
      itemType: json['item_type'] ?? '',
      status: json['status'] ?? 'قيد التنفيذ',
      amount: json['amount'] != null ? double.parse(json['amount'].toString()) : null,
      description: json['description'],
      category: json['category'],
      donationDate: json['donation_date'] != null 
          ? DateTime.parse(json['donation_date']) 
          : null,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
    );
  }

  /// تحويل من نموذج إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'donor_name': donorName,
      'item_type': itemType,
      'status': status,
      'amount': amount,
      'description': description,
      'category': category,
      'donation_date': donationDate?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
    };
  }

  /// نسخ مع تحديث بعض الحقول
  DonationModel copyWith({
    int? id,
    String? donorName,
    String? itemType,
    String? status,
    double? amount,
    String? description,
    String? category,
    DateTime? donationDate,
    DateTime? createdAt,
  }) {
    return DonationModel(
      id: id ?? this.id,
      donorName: donorName ?? this.donorName,
      itemType: itemType ?? this.itemType,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      category: category ?? this.category,
      donationDate: donationDate ?? this.donationDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() => 'DonationModel(id: $id, donor: $donorName, item: $itemType, status: $status)';
}
