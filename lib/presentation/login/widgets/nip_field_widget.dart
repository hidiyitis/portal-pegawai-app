import 'package:flutter/material.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_colors.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_text_size.dart';

class NipFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final FormFieldValidator<String>? validator;
  final void Function(String)? onChanged;
  final TextInputAction? textInputAction;
  final bool? autoFocus;
  const NipFieldWidget({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.onChanged,
    this.textInputAction,
    this.autoFocus,
  });

  @override
  State<NipFieldWidget> createState() => _NipFieldWidgetState();
}

class _NipFieldWidgetState extends State<NipFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'NIP',
          style: TextStyle(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: AppTextSize.bodyMedium,
          ),
        ),
        TextFormField(
          controller: widget.controller,
          cursorColor: AppColors.primary,
          decoration: InputDecoration(
            label: Text(
              widget.labelText,
              style: TextStyle(fontSize: AppTextSize.bodySmall),
            ),
          ),
        ),
      ],
    );
  }
}
