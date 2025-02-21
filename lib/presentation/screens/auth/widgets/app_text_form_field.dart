import 'package:leanware_test/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String labelText;
  final bool? obscureText;

  const AppTextFormField(
      {super.key,
      required this.controller,
      this.validator,
      required this.labelText,
      this.obscureText});

  @override
  Widget build(BuildContext context) {
    final outputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.primary),
    );
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: AppColors.primary),
        enabledBorder: outputBorder,
        focusedBorder: outputBorder,
      ),
      validator: validator,
      obscureText: obscureText ?? false,
    );
  }
}
