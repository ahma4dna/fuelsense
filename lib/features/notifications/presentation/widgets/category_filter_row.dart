import 'package:flutter/material.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:fuelsense/core/widget/smooth_animations.dart';

class CategoryFilterRow extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onSelectCategory;

  const CategoryFilterRow({
    super.key,
    required this.selectedCategory,
    required this.onSelectCategory,
  });

  @override
  Widget build(BuildContext context) {
    final appContext = AppContext.of(context);

    final filters = [
      ('all', appContext.localText.filter_all),
      ('open', appContext.localText.filter_open_now),
      ('refilling', appContext.localText.status_refilled),
      ('on_the_way', appContext.localText.status_on_the_way),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(filters.length, (index) {
          final item = filters[index];
          final isLast = index == filters.length - 1;

          return Padding(
            padding: EdgeInsetsDirectional.only(
              end: isLast ? AppSize.s0 : AppPadding.p8,
            ),
            child: CategoryFilterChip(
              label: item.$2,
              isSelected: selectedCategory == item.$1,
              onTap: () => onSelectCategory(item.$1),
            ),
          );
        }),
      ),
    );
  }
}

class CategoryFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PressScale(
      scale: AppSize.s0_95,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.p16,
            vertical: AppPadding.p10,
          ),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF0E2925) : const Color(0xFFF3F1EA),
            borderRadius: BorderRadius.circular(AppSize.s22),
            border: Border.all(
              color: isSelected ? const Color(0xFF0E2925) : const Color(0xFFE2DFD5),
              width: AppSize.s1,
            ),
          ),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            style: isSelected
                ? AppStyles.getBold(
                    context: context,
                    fontSize: AppSize.s13,
                    color: Colors.white,
                  )
                : AppStyles.getMeduim(
                    context: context,
                    fontSize: AppSize.s13,
                    color: const Color(0xFF374543),
                  ),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}
