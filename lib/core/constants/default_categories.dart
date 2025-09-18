import 'package:flutter/material.dart';
import 'package:pocketa/features/categories/domain/entities/category_entity.dart';
import 'package:pocketa/features/transaction/domain/entities/transaction_type.dart';

CategoryKind kindFromTxType(TransactionType t) {
  switch (t) {
    case TransactionType.income:
      return CategoryKind.income;
    case TransactionType.transfer:
      return CategoryKind.transfer;
    case TransactionType.expense:
      return CategoryKind.expense;
  }
}

List<CategoryEntity> defaultCategoriesByKind(CategoryKind kind) =>
    defaultCategories.where((c) => c.kind == kind).toList();

final List<CategoryEntity> defaultIncomeCategories = [
  CategoryEntity(
    id: 'inc_salary',
    name: 'cat_salary_name',
    kind: CategoryKind.income,
    iconCodePoint: Icons.payments.codePoint,
    iconFontFamily: 'MaterialIcons',
    colorHex: 0xFF4CAF50,
    isDefault: true,
    createdAt: DateTime.now().toUtc(),
  ),
  CategoryEntity(
    id: 'inc_business',
    name: 'cat_business_name',
    kind: CategoryKind.income,
    iconCodePoint: Icons.store.codePoint,
    iconFontFamily: 'MaterialIcons',
    colorHex: 0xFF009688,
    isDefault: true,
    createdAt: DateTime.now().toUtc(),
  ),
  CategoryEntity(
    id: 'inc_invest',
    name: 'cat_investment_name',
    kind: CategoryKind.income,
    iconCodePoint: Icons.trending_up.codePoint,
    iconFontFamily: 'MaterialIcons',
    colorHex: 0xFF3F51B5,
    isDefault: true,
    createdAt: DateTime.now().toUtc(),
  ),
];

final List<CategoryEntity> defaultExpenseCategories = [
  CategoryEntity(
    id: 'exp_food',
    name: 'cat_food_dining_name',
    kind: CategoryKind.expense,
    iconCodePoint: Icons.restaurant.codePoint,
    iconFontFamily: 'MaterialIcons',
    colorHex: 0xFFF44336,
    isDefault: true,
    createdAt: DateTime.now().toUtc(),
  ),
  CategoryEntity(
    id: 'exp_transport',
    name: 'cat_transport_name',
    kind: CategoryKind.expense,
    iconCodePoint: Icons.directions_bus.codePoint,
    iconFontFamily: 'MaterialIcons',
    colorHex: 0xFF9C27B0,
    isDefault: true,
    createdAt: DateTime.now().toUtc(),
  ),
  CategoryEntity(
    id: 'exp_rent',
    name: 'cat_rent_name',
    kind: CategoryKind.expense,
    iconCodePoint: Icons.home.codePoint,
    iconFontFamily: 'MaterialIcons',
    colorHex: 0xFF795548,
    isDefault: true,
    createdAt: DateTime.now().toUtc(),
  ),
  CategoryEntity(
    id: 'exp_shopping',
    name: 'cat_shopping_name',
    kind: CategoryKind.expense,
    iconCodePoint: Icons.shopping_bag.codePoint,
    iconFontFamily: 'MaterialIcons',
    colorHex: 0xFFE91E63,
    isDefault: true,
    createdAt: DateTime.now().toUtc(),
  ),
];

final List<CategoryEntity> defaultTransferCategories = [
  CategoryEntity(
    id: 'trf_bank',
    name: 'cat_bank_transfer_name',
    kind: CategoryKind.transfer,
    iconCodePoint: Icons.account_balance.codePoint,
    iconFontFamily: 'MaterialIcons',
    colorHex: 0xFF2196F3,
    isDefault: true,
    createdAt: DateTime.now().toUtc(),
  ),
  CategoryEntity(
    id: 'trf_mfs',
    name: 'cat_mobile_wallet_name',
    kind: CategoryKind.transfer,
    iconCodePoint: Icons.phone_iphone.codePoint,
    iconFontFamily: 'MaterialIcons',
    colorHex: 0xFF607D8B,
    isDefault: true,
    createdAt: DateTime.now().toUtc(),
  ),
];

/// Master list
final List<CategoryEntity> defaultCategories = [
  ...defaultIncomeCategories,
  ...defaultExpenseCategories,
  ...defaultTransferCategories,
];
