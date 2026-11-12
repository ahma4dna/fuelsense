import 'package:flutter/material.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';

class NotificationStatusIconBox extends StatelessWidget {
  final IconData icon;
  final Color accentColor;
  final Color backgroundColor;

  const NotificationStatusIconBox({
    super.key,
    required this.icon,
    required this.accentColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSize.s45,
      height: AppSize.s45,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSize.s14),
      ),
      child: Icon(
        icon,
        color: accentColor,
        size: AppSize.s24,
      ),
    );
  }
}
