import 'package:flutter/material.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:gap/gap.dart';

class StatusCounterItem extends StatelessWidget {
  final int count;
  final String label;
  final Color dotColor;
  final bool isSelected;
  final VoidCallback onTap;

  const StatusCounterItem({
    super.key,
    required this.count,
    required this.label,
    required this.dotColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSize.s12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$count',
            style: AppStyles.getExtraBold(
              context: context,
              fontSize: AppSize.s22,
              color: isSelected ? dotColor : Colors.white,
            ).copyWith(height: AppSize.s1_02),
          ),
          const Gap(AppSize.s6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: AppSize.s8,
                height: AppSize.s8,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const Gap(AppSize.s5),
              Text(
                label,
                style: isSelected
                    ? AppStyles.getExtraBold(
                        context: context,
                        fontSize: AppSize.s12,
                        color: Colors.white,
                      )
                    : AppStyles.getMeduim(
                        context: context,
                        fontSize: AppSize.s12,
                        color: const Color(0xFFA7C4C0),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
