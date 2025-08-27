import 'package:flutter/material.dart';
import 'package:pocketa/widgets/input/app_text_form_field.dart';

class NoteField extends StatelessWidget {
  final TextEditingController controller;
  const NoteField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      controller: controller,
      label: 'Note',
      prefixIcon: Icons.note_outlined,
      maxLines: 3,
      hintText: 'Optional',
      validator: (_) => null,
    );
  }
}
