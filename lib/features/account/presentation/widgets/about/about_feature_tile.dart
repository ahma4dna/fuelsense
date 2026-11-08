import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';

class AboutFeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const AboutFeatureTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppPadding.p10),
      padding: const EdgeInsets.all(AppPadding.p14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSize.s16),
        border: Border.all(
          color: const Color(0xFFE6E2D9),
          width: AppSize.s1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: AppSize.s40,
            height: AppSize.s40,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF9F7),
              borderRadius: BorderRadius.circular(AppSize.s12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF0F6E67),
              size: AppSize.s22,
            ),
          ),
          const Gap(AppSize.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.getExtraBold(
                    context: context,
                    fontSize: AppSize.s14_5,
                    color: const Color(0xFF11201F),
                  ),
                ),
                const Gap(AppSize.s2),
                Text(
                  subtitle,
                  style: AppStyles.getMeduim(
                    context: context,
                    fontSize: AppSize.s12,
                    color: const Color(0xFF5A6866),
                  ).copyWith(height: AppSize.s1_4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
