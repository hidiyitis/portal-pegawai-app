import 'package:flutter/material.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_text_size.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({
    super.key,
    required this.icon,
    required this.label,
    this.nextPage,
    this.onTap,
  });
  final IconData icon;
  final String label;
  final String? nextPage;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Navigator.pushNamed(context, nextPage!),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: 16,
            children: [
              Icon(icon),
              Text(label, style: TextStyle(fontSize: AppTextSize.bodyMedium)),
            ],
          ),
          Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}
