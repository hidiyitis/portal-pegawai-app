import 'package:flutter/material.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_colors.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_text_size.dart';

class PasswordFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final FormFieldValidator<String>? validator;
  final void Function(String)? onChanged;
  final TextInputAction? textInputAction;
  final bool? autoFocus;
  const PasswordFieldWidget({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.onChanged,
    this.textInputAction,
    this.autoFocus,
  });

  @override
  State<PasswordFieldWidget> createState() => _PasswordFieldWidgetState();
}

class _PasswordFieldWidgetState extends State<PasswordFieldWidget> {
  final bool _obsecure = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: TextStyle(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: AppTextSize.bodyMedium,
          ),
        ),
        TextFormField(
          controller: widget.controller,
          obscureText: _obsecure,
          cursorColor: AppColors.primary,
          decoration: InputDecoration(
            label: Text(
              widget.labelText,
              style: TextStyle(fontSize: AppTextSize.bodySmall),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Harap masukkan password';
            }
            if (value.length < 8) {
              return 'Password minimal 8 karakter';
            }
            return null;
          },
        ),
      ],
    );
  }
}
