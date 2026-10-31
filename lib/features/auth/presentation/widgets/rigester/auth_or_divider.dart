import 'package:flutter/material.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';

class AuthOrDivider extends StatelessWidget {
  final String text;
  const AuthOrDivider({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(color: Color(0xFFE4E0D6), thickness: 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p14),
          child: Text(
            text,
            style: AppStyles.getMeduim(
              context: context,
              fontSize: AppSize.s13,
              color: Color(0xFF7B8886),
            ),
          ),
        ),
        const Expanded(
          child: Divider(color: Color(0xFFE4E0D6), thickness: 1),
        ),
      ],
    );
  }
}
