import 'package:flutter/material.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:fuelsense/features/stations_directory/presentation/widgets/filters/city_option_tile.dart';
import 'package:gap/gap.dart';

import '../../../domain/enums/station_directory_enums.dart';

class StatusFilterBottomSheet extends StatelessWidget {
  final StationStatusFilter selectedFilter;
  final ValueChanged<StationStatusFilter> onFilterSelected;

  const StatusFilterBottomSheet({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  static Future<void> show({
    required BuildContext context,
    required StationStatusFilter selectedFilter,
    required ValueChanged<StationStatusFilter> onFilterSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFF6F4EE),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSize.s28),
        ),
      ),
      builder: (_) => StatusFilterBottomSheet(
        selectedFilter: selectedFilter,
        onFilterSelected: onFilterSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appContext = AppContext.of(context);

    final filters = [
      (StationStatusFilter.all, appContext.localText.filter_all_statuses),
      (StationStatusFilter.open, appContext.localText.filter_open_only),
      (StationStatusFilter.refilling, appContext.localText.filter_refilling),
      (StationStatusFilter.onTheWay, appContext.localText.filter_on_the_way),
      (StationStatusFilter.closed, appContext.localText.filter_closed),
    ];

    return Directionality(
      textDirection: appContext.isRt ? TextDirection.rtl : TextDirection.ltr,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppPadding.p20,
            AppPadding.p16,
            AppPadding.p20,
            AppPadding.p24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: AppSize.s44,
                  height: AppSize.s4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD0CCC2),
                    borderRadius: BorderRadius.circular(AppSize.s10),
                  ),
                ),
              ),
              const Gap(AppSize.s18),
              Text(
                appContext.localText.filter_by_status_title,
                style: AppStyles.getExtraBold(
                  context: context,
                  fontSize: AppSize.s18,
                  color: const Color(0xFF11201F),
                ),
              ),
              const Gap(AppSize.s14),
              Expanded(
                child: ListView.builder(
                  itemCount: filters.length,

                  itemBuilder: (context, index) {
                    final item = filters[index];
                    return StatusFilterTile(
                      title: item.$2,
                      isSelected: selectedFilter == item.$1,
                      onTap: () {
                        onFilterSelected(item.$1);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
