import 'package:flutter/material.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';

import '../../../domain/enums/station_directory_enums.dart';

class SmartSortChipsBar extends StatelessWidget {
  final StationSortOption selectedSort;
  final ValueChanged<StationSortOption> onSortChanged;

  const SmartSortChipsBar({
    super.key,
    required this.selectedSort,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    final appContext = AppContext.of(context);

    final options = [
      (StationSortOption.nearest, appContext.localText.sort_nearest),
      (StationSortOption.latestUpdated, appContext.localText.sort_latest_updated),
      (StationSortOption.leastCrowded, appContext.localText.sort_least_crowded),
    ];

    return Row(
      children: options.map((item) {
        final isSelected = selectedSort == item.$1;
        return Expanded(
          child: Padding(
            padding: EdgeInsetsDirectional.only(
              end: item.$1 != StationSortOption.leastCrowded ? AppPadding.p8 : AppSize.s0,
            ),
            child: GestureDetector(
              onTap: () => onSortChanged(item.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: AppSize.s44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF0E2925) : const Color(0xFFF3F1EA),
                  borderRadius: BorderRadius.circular(AppSize.s24),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF0E2925) : const Color(0xFFE2DFD5),
                    width: AppSize.s1,
                  ),
                ),
                child: Text(
                  item.$2,
                  style: isSelected
                      ? AppStyles.getBold(
                          context: context,
                          fontSize: AppSize.s13_5,
                          color: Colors.white,
                        )
                      : AppStyles.getMeduim(
                          context: context,
                          fontSize: AppSize.s13_5,
                          color: const Color(0xFF374543),
                        ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
