import 'package:flutter/material.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:gap/gap.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? trailingBadge;
  final VoidCallback onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailingBadge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appContext = AppContext.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSize.s20),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p16,
          vertical: AppPadding.p14,
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
                      fontSize: AppSize.s15,
                      color: const Color(0xFF11201F),
                    ),
                  ),
                  const Gap(AppSize.s2),
                  Text(
                    subtitle,
                    style: AppStyles.getMeduim(
                      context: context,
                      fontSize: AppSize.s12,
                      color: const Color(0xFF6B7B79),
                    ),
                  ),
                ],
              ),
            ),
            if (trailingBadge != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.p8,
                  vertical: AppPadding.p4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F1EA),
                  borderRadius: BorderRadius.circular(AppSize.s8),
                ),
                child: Text(
                  trailingBadge!,
                  style: AppStyles.getBold(
                    context: context,
                    fontSize: AppSize.s12,
                    color: const Color(0xFF0F6E67),
                  ),
                ),
              ),
              const Gap(AppSize.s6),
            ],
            Icon(
              appContext.isRt ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
              color: const Color(0xFF8C9896),
              size: AppSize.s24,
            ),
          ],
        ),
      ),
    );
  }
}
