import 'package:flutter/material.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';

class CardMiniIconBox extends StatelessWidget {
  final IconData icon;

  const CardMiniIconBox({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSize.s32,
      height: AppSize.s32,
      decoration: BoxDecoration(
        color: const Color(0xFFF6F4EE),
        borderRadius: BorderRadius.circular(AppSize.s10),
        border: Border.all(
          color: const Color(0xFFE8E4DA),
          width: AppSize.s1,
        ),
      ),
      child: Icon(
        icon,
        size: AppSize.s17,
        color: const Color(0xFF5A6866),
      ),
    );
  }
}
