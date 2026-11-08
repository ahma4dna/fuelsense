import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';

class SectionHeaderTitle extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  const SectionHeaderTitle({
    super.key,
    required this.title,
    this.actionLabel,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppStyles.getExtraBold(
            context: context,
            fontSize: AppSize.s15,
            color: const Color(0xFF374543),
          ),
        ),
        if (actionLabel != null && onActionTap != null)
          GestureDetector(
            onTap: onActionTap,
            child: Row(
              children: [
                const Icon(
                  Icons.edit_note_rounded,
                  size: AppSize.s18,
                  color: Color(0xFF0F6E67),
                ),
                const Gap(AppSize.s4),
                Text(
                  actionLabel!,
                  style: AppStyles.getBold(
                    context: context,
                    fontSize: AppSize.s13,
                    color: const Color(0xFF0F6E67),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
