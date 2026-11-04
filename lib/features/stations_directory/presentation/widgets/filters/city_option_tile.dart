import 'package:flutter/material.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';

class StatusFilterTile extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const StatusFilterTile({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSize.s14),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppPadding.p8),
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p16,
          vertical: AppPadding.p14,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEEF9F7) : Colors.white,
          borderRadius: BorderRadius.circular(AppSize.s14),
          border: Border.all(
            color: isSelected ? const Color(0xFF0F6E67) : const Color(0xFFE6E2D9),
            width: isSelected ? AppSize.s1_5 : AppSize.s1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: isSelected
                    ? AppStyles.getExtraBold(
                        context: context,
                        fontSize: AppSize.s14_5,
                        color: const Color(0xFF0F6E67),
                      )
                    : AppStyles.getMeduim(
                        context: context,
                        fontSize: AppSize.s14_5,
                        color: const Color(0xFF11201F),
                      ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF0F6E67),
                size: AppSize.s20,
              ),
          ],
        ),
      ),
    );
  }
}
