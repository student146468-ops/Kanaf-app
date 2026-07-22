import 'package:flutter/material.dart';

class NeedModel {
  final int id;
  final String title;
  final String description;
  final String category;
  final String needType;
  final String priority;
  final String requiredQuantity;
  final double fulfilledQuantity;
  final String status;
  final String? imageUrl;
  final DateTime? deadline;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const NeedModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.needType,
    required this.priority,
    required this.requiredQuantity,
    required this.fulfilledQuantity,
    required this.status,
    this.imageUrl,
    this.deadline,
    this.createdAt,
    this.updatedAt,
  });

  factory NeedModel.fromJson(Map<String, dynamic> json) {
    return NeedModel(
      id: _asInt(json['id']),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      needType: json['need_type']?.toString() ?? '',
      priority: json['priority']?.toString() ?? '',
      requiredQuantity: json['required_quantity']?.toString() ?? '',
      fulfilledQuantity: _asDouble(json['fulfilled_quantity']),
      status: json['status']?.toString() ?? '',
      imageUrl: json['image_url']?.toString(),
      deadline: _asDate(json['deadline']),
      createdAt: _asDate(json['created_at']),
      updatedAt: _asDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'need_type': needType,
      'priority': priority,
      'required_quantity': requiredQuantity,
      'fulfilled_quantity': fulfilledQuantity,
      'status': status,
      'deadline': deadline?.toIso8601String().split('T').first,
    };
  }

  Map<String, dynamic> toCareHomeMap() {
    return {
      'id': id.toString(),
      'title': title,
      'category': category,
      'quantity': requiredQuantity,
      'priority': priorityLabel,
      'status': statusLabel,
      'details': description,
      'date_published': createdAt == null
          ? ''
          : '${createdAt!.year}-${createdAt!.month.toString().padLeft(2, '0')}-${createdAt!.day.toString().padLeft(2, '0')}',
      'icon': icon,
      'color': color,
      'image_url': imageUrl,
      'current_step': status == 'completed' ? 3 : 0,
    };
  }

  String get statusLabel {
    if (status == 'completed') return 'ظ…ظƒطھظ…ظ„';
    if (status == 'archived') return 'ظ…ط¤ط±ط´ظپ';
    return 'ظ‚ظٹط¯ ط§ظ„طھظ†ظپظٹط°';
  }

  String get priorityLabel {
    if (priority == 'urgent') return 'ط¹ط§ط¬ظ„';
    if (priority == 'low') return 'ظ…ظ†ط®ظپط¶';
    if (priority == 'medium') return 'ظ…طھظˆط³ط·';
    return priority.isEmpty ? 'ظ…طھظˆط³ط·' : priority;
  }

  IconData get icon {
    switch (category) {
      case 'ط·ط¨ظٹ':
      case 'medical':
        return Icons.health_and_safety_rounded;
      case 'ط؛ط°ط§ط¦ظٹ':
      case 'food':
        return Icons.bakery_dining_rounded;
      case 'ظƒط³ظˆط©':
      case 'clothes':
        return Icons.checkroom_rounded;
      case 'طھط¹ظ„ظٹظ…ظٹ':
      case 'education':
        return Icons.school_rounded;
      default:
        return Icons.inventory_2_outlined;
    }
  }

  Color get color {
    switch (category) {
      case 'ط·ط¨ظٹ':
      case 'medical':
        return Colors.redAccent;
      case 'ط؛ط°ط§ط¦ظٹ':
      case 'food':
        return Colors.amber;
      case 'ظƒط³ظˆط©':
      case 'clothes':
        return const Color(0xFF14B8A6);
      case 'طھط¹ظ„ظٹظ…ظٹ':
      case 'education':
        return Colors.blueAccent;
      default:
        return Colors.grey;
    }
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _asDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static DateTime? _asDate(dynamic value) {
    if (value == null || value.toString().isEmpty) return null;
    return DateTime.tryParse(value.toString());
  }
}
