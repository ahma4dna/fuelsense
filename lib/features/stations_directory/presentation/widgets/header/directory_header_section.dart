import 'package:flutter/material.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:fuelsense/features/stations_directory/presentation/widgets/header/status_counter_item.dart';
import 'package:gap/gap.dart';

import '../../../domain/enums/station_directory_enums.dart';

class DirectoryHeaderSection extends StatelessWidget {
  final String cityLabel;
  final int openCount;
  final int refillingCount;
  final int onTheWayCount;
  final int closedCount;
  final StationStatusFilter activeFilter;
  final VoidCallback onFilterButtonTap;
  final ValueChanged<StationStatusFilter> onStatusCounterTap;

  const DirectoryHeaderSection({
    super.key,
    required this.cityLabel,
    required this.openCount,
    required this.refillingCount,
    required this.onTheWayCount,
    required this.closedCount,
    required this.activeFilter,
    required this.onFilterButtonTap,
    required this.onStatusCounterTap,
  });

  @override
  Widget build(BuildContext context) {
    final appContext = AppContext.of(context);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF07332C),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppSize.s30),
          bottomRight: Radius.circular(AppSize.s30),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppPadding.p16,
            AppPadding.p12,
            AppPadding.p16,
            AppPadding.p20,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    appContext.localText.stations_directory_title,
                    style: AppStyles.getExtraBold(
                      context: context,
                      fontSize: AppSize.s28,
                      color: Colors.white,
                    ),
                  ),
                  InkWell(
                    onTap: onFilterButtonTap,
                    borderRadius: BorderRadius.circular(AppSize.s24),
                    child: Container(
                      width: AppSize.s44,
                      height: AppSize.s44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D443B),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF216258),
                          width: AppSize.s1,
                        ),
                      ),
                      child: const Icon(
                        Icons.tune_rounded,
                        color: Color(0xFFD6E6E3),
                        size: AppSize.s20,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(AppSize.s16),
              Container(
                padding: const EdgeInsets.symmetric(vertical: AppPadding.p14),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A3D35),
                  borderRadius: BorderRadius.circular(AppSize.s18),
                  border: Border.all(
                    color: const Color(0xFF175249),
                    width: AppSize.s1,
                  ),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: StatusCounterItem(
                          count: openCount,
                          label: appContext.localText.open,
                          dotColor: const Color(0xFF22C55E),
                          isSelected: activeFilter == StationStatusFilter.open,
                          onTap: () => onStatusCounterTap(StationStatusFilter.open),
                        ),
                      ),
                      const VerticalDivider(
                        color: Color(0xFF1A524A),
                        thickness: AppSize.s1,
                        width: AppSize.s1,
                      ),
                      Expanded(
                        child: StatusCounterItem(
                          count: refillingCount,
                          label: appContext.localText.status_refilled,
                          dotColor: const Color(0xFFF59E0B),
                          isSelected: activeFilter == StationStatusFilter.refilling,
                          onTap: () => onStatusCounterTap(StationStatusFilter.refilling),
                        ),
                      ),
                      const VerticalDivider(
                        color: Color(0xFF1A524A),
                        thickness: AppSize.s1,
                        width: AppSize.s1,
                      ),
                      Expanded(
                        child: StatusCounterItem(
                          count: onTheWayCount,
                          label: appContext.localText.status_on_the_way,
                          dotColor: const Color(0xFF3B82F6),
                          isSelected: activeFilter == StationStatusFilter.onTheWay,
                          onTap: () => onStatusCounterTap(StationStatusFilter.onTheWay),
                        ),
                      ),
                      const VerticalDivider(
                        color: Color(0xFF1A524A),
                        thickness: AppSize.s1,
                        width: AppSize.s1,
                      ),
                      Expanded(
                        child: StatusCounterItem(
                          count: closedCount,
                          label: appContext.localText.status_unknown,
                          dotColor: const Color(0xFF8B9D9B),
                          isSelected: activeFilter == StationStatusFilter.closed,
                          onTap: () => onStatusCounterTap(StationStatusFilter.closed),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
