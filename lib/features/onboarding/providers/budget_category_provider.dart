// lib/features/budget/controller/budget_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/budget_category_model.dart';

final selectedCategoriesProvider =
    StateNotifierProvider<SelectedCategoriesNotifier, List<BudgetCategory>>(
      (ref) => SelectedCategoriesNotifier(),
    );

class SelectedCategoriesNotifier extends StateNotifier<List<BudgetCategory>> {
  SelectedCategoriesNotifier() : super([]);

  void toggleCategory(BudgetCategory category) {
    if (state.any((c) => c.id == category.id)) {
      state = state.where((c) => c.id != category.id).toList();
    } else {
      state = [...state, category];
    }
  }

  void updateLimit(String id, double newLimit) {
    state =
        state.map((c) {
          return c.id == id ? c.copyWith(limit: newLimit) : c;
        }).toList();
  }

  bool isSelected(String id) {
    return state.any((c) => c.id == id);
  }
}
