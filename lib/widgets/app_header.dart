import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final bool showBack;
  final VoidCallback onMenuTap;

  const AppHeader({
    super.key,
    this.title = 'Dashboard',
    this.showBack = false,
    required this.onMenuTap,
  });

  // Rakibul Islam Mehedi
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            onPressed: onMenuTap,
            icon: showBack
                ? Icon(Icons.arrow_back_ios_new_outlined, size: 28)
                : Icon(Icons.menu, size: 28),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: theme.textTheme.headlineMedium?.fontSize,
              fontWeight: theme.textTheme.headlineMedium?.fontWeight,
            ),
          ),
        ],
      ),
    );
  }
}
