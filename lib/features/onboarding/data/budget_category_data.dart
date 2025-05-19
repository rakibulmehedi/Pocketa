import 'package:flutter/material.dart';

import '../model/budget_category_model.dart';
import '../model/grid_item_model.dart';

final List<BudgetCategory> defaultBudgetCategories = [
  BudgetCategory(
    id: 'food',
    name: 'Food',
    icon: Icons.fastfood,
    color: Colors.red,
    limit: 0,
  ),
  BudgetCategory(
    id: 'transport',
    name: 'Transport',
    icon: Icons.directions_car,
    color: Colors.blue,
    limit: 0,
  ),
  BudgetCategory(
    id: 'shopping',
    name: 'Shopping',
    icon: Icons.shopping_bag,
    color: Colors.purple,
    limit: 0,
  ),
  BudgetCategory(
    id: 'entertainment',
    name: 'Entertainment',
    icon: Icons.movie,
    color: Colors.green,
    limit: 0,
  ),
  BudgetCategory(
    id: 'bills',
    name: 'Bills',
    icon: Icons.receipt,
    color: Colors.orange,
    limit: 0,
  ),
];

final List<GridItemModel> budgetCategoryItems =
    defaultBudgetCategories
        .map((e) => GridItemModel(label: e.name, icon: e.icon, color: e.color))
        .toList();
