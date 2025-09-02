import 'package:flutter/material.dart';
import 'package:pocketa/shared/widgets/input/app_text_form_field.dart';
import 'package:pocketa/l10n/app_localizations.dart';

class NoteField extends StatelessWidget {
  final TextEditingController controller;
  const NoteField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return AppTextFormField(
      controller: controller,
      label: t.note,
      prefixIcon: Icons.note_outlined,
      maxLines: 3,
      hintText: t.optional,
      validator: (_) => null,
    );
  }
}
