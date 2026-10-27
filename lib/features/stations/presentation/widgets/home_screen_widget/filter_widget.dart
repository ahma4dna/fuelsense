import 'package:flutter/material.dart';
import 'package:fuelsense/core/application/resource/app_colors.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:fuelsense/features/stations/domain/enums/station_enums.dart';
import 'package:fuelsense/features/stations/domain/extensions/station_extensions.dart';
import 'package:gap/gap.dart';

class FilterWidget extends StatelessWidget {
  final StationQuickFilter filter;
  final bool isSelected;
  final void Function()? onTap;

  const new({
    super.key,
    required this.filter,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p14,
          vertical: AppPadding.p10,
        ),
        height: AppSize.s50,
        decoration: BoxDecoration(
          color: isSelected ? Color(0XFF0F6E67) : AppColors.white,
          borderRadius: BorderRadius.circular(16777200),
        ),
        duration: Duration(milliseconds: 300),
        margin: EdgeInsets.only(
          right: AppPadding.p8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (filter != StationQuickFilter.all)
              Container(
                width: AppSize.s10,
                height: AppSize.s10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: filter.getFilterColors,
                ),
              ),
            if (filter != StationQuickFilter.all) const Gap(AppSize.s5),
            Text(
              filter.arabicLabel,
              style: AppStyles.getBold(
                context: context,
                color: isSelected ? Colors.white : const Color(0xFF11201F),
                fontSize: AppSize.s13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
