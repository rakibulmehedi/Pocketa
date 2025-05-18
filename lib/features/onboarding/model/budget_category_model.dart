// lib/features/budget/model/budget_category.dart
import 'package:flutter/material.dart';

class BudgetCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final double limit;

  BudgetCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.limit,
  });

  BudgetCategory copyWith({
    String? id,
    String? name,
    IconData? icon,
    Color? color,
    double? limit,
  }) {
    return BudgetCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      limit: limit ?? this.limit,
    );
  }
}
