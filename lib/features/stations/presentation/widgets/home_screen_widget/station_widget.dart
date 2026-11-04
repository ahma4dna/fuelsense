import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fuelsense/core/application/resource/app_assets.dart';
import 'package:fuelsense/core/application/resource/app_colors.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:fuelsense/features/stations/domain/entities/field_report_entity.dart';
import 'package:fuelsense/features/stations/domain/entities/station_entity.dart';
import 'package:fuelsense/features/stations/domain/enums/station_enums.dart';
import 'package:fuelsense/features/stations/domain/extensions/station_extensions.dart';
import 'package:fuelsense/features/stations/presentation/bloc/stations_state.dart';
import 'package:fuelsense/features/stations/presentation/widgets/station_details_widget/delay_percentage_badge.dart';
import 'package:fuelsense/features/stations/presentation/widgets/station_details_widget/three_segment_traffic_gauge.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StationWidget extends StatelessWidget {
  const StationWidget({
    super.key,
    required this.selectedStation,
    this.userLocation,
    this.todayReports = const [],
    this.onViewDetailsPressed,
    this.onOpenRoutePressed,
    required this.state,
  });

  final StationEntity? selectedStation;
  final StationsState state;
  final LatLng? userLocation;
  final List<FieldReportEntity> todayReports;
  final VoidCallback? onViewDetailsPressed;
  final VoidCallback? onOpenRoutePressed;

  String _getDistanceInKm() {
    final station = selectedStation;
    final location = userLocation;

    if (station == null || location == null) return '--';

    final meters = station.distanceFromUser(
      userLat: location.latitude,
      userLng: location.longitude,
    );

    return (meters / 1000).toStringAsFixed(1);
  }

  String _getOfficialStatusDetails() {
    final station = selectedStation;

    if (station == null) return '';

    final notes = station.statusNotes?.trim();

    if (notes != null && notes.isNotEmpty) {
      return notes;
    }

    final fuelAmount = station.lastFuelAmount?.trim();

    final amount = fuelAmount != null && fuelAmount.isNotEmpty ? ' ($fuelAmount)' : '';

    return '${station.status.arabicLabel}$amount';
  }

  String get fullTraffic {
    final station = selectedStation;

    if (station == null) return '';

    final delay = station.trafficDelayRatio;
    final description = station.trafficDescription;

    return delay > 0 ? 'حالة الطريق: $description (+$delay% تأخير)' : 'حالة الطريق: $description';
  }

  Color get _statusAccentColor {
    switch (selectedStation?.status) {
      case OfficialStationStatus.open:
        return const Color(0xFF16A34A);

      case OfficialStationStatus.refilling:
        return const Color(0xFFF08A00);

      case OfficialStationStatus.onTheWay:
        return const Color(0xFF0F6E67);

      case OfficialStationStatus.closed:
      case OfficialStationStatus.outOfFuel:
        return const Color(0xFFD92D20);

      case OfficialStationStatus.unknown:
      case null:
        return const Color(0xFF7B8886);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppContext appContext = AppContext.of(context);
    final FieldReportEntity? latestReport = todayReports.isNotEmpty ? todayReports.first : null;
    final int reportsCount = todayReports.isNotEmpty ? todayReports.length : (selectedStation?.totalReports ?? 0);

    return AnimatedSlide(
      duration: const Duration(milliseconds: 500),
      offset: selectedStation != null ? Offset.zero : const Offset(0, 1.2),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 300),
        scale: selectedStation != null ? 1.0 : 0.8,
        child: Container(
          padding: EdgeInsets.only(
            top: AppPadding.p8,
            left: AppPadding.p16,
            right: AppPadding.p16,
            bottom: AppPadding.p16,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(38),
            color: AppColors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: AppSize.s40,
                height: AppSize.s5,
                decoration: ShapeDecoration(
                  color: const Color(0xFFE6E2D9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16777200),
                  ),
                ),
              ),
              const Gap(AppSize.s6),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedStation != null ? "${selectedStation!.name} - ${selectedStation!.city}" : "",
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: AppStyles.getExtraBold(
                        context: context,
                        color: const Color(0xFF11201F),
                        fontSize: AppSize.s17,
                      ),
                    ),
                  ),
                  SvgPicture.asset(
                    width: AppSize.s20,
                    height: AppSize.s20,
                    AppAssets.locationDistance,
                    fit: BoxFit.cover,
                  ),
                  const Gap(AppSize.s4),
                  Text(
                    _getDistanceInKm(),
                    style: AppStyles.getMeduim(
                      context: context,
                      color: const Color(0xFF4A5957),
                      fontSize: AppSize.s16,
                    ),
                  ),
                  const Gap(AppSize.s4),
                  Text(
                    appContext.localText.km,
                    style: AppStyles.getMeduim(
                      context: context,
                      color: const Color(0xFF4A5957),
                      fontSize: AppSize.s16,
                    ),
                  ),
                ],
              ),
              const Gap(AppSize.s8),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      color: _statusAccentColor,
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(
                          color: const Color(0xFFE6E2D9),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(14),
                          bottomLeft: Radius.circular(14),
                          topRight: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: AppPadding.p12,
                          bottom: AppPadding.p10,
                          top: AppPadding.p10,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Gap(AppSize.s16),
                            SvgPicture.asset(
                              width: AppSize.s45,
                              height: AppSize.s45,
                              AppAssets.stateStaion,
                              fit: BoxFit.cover,
                            ),
                            const Gap(AppSize.s12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    appContext.localText.station_statee,
                                    style: AppStyles.getBold(
                                      context: context,
                                      color: const Color(0xFFB54708),
                                      fontSize: AppSize.s16,
                                    ),
                                  ),
                                  const Gap(AppSize.s5),
                                  Text(
                                    _getOfficialStatusDetails(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppStyles.getBold(
                                      context: context,
                                      color: const Color(0xFF11201F),
                                      fontSize: AppSize.s14,
                                    ),
                                  ),
                                  const Gap(AppSize.s5),
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        width: AppSize.s16,
                                        height: AppSize.s16,
                                        AppAssets.clock,
                                        fit: BoxFit.cover,
                                      ),
                                      const Gap(AppSize.s5),
                                      Text(
                                        selectedStation?.lastUpdatedRelativeText ?? '',
                                        textAlign: TextAlign.right,
                                        style: AppStyles.getMeduim(
                                          context: context,
                                          color: const Color(0xFF4A5957),
                                          fontSize: AppSize.s14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(AppSize.s8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFE6E2D9),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullTraffic,
                      style: AppStyles.getBold(
                        context: context,
                        fontSize: AppSize.s14,
                        color: const Color(0xFF4A5957),
                      ),
                    ),
                    const Gap(AppSize.s12),
                    Row(
                      children: [
                        Expanded(
                          child: ThreeSegmentTrafficGauge(
                            trafficLevel: selectedStation?.trafficStatus ?? TrafficLevel.normal,
                          ),
                        ),
                        const Gap(AppSize.s12),
                        DelayPercentageBadge(
                          delayPercentage: selectedStation?.trafficDelayRatio ?? 0,
                          trafficLevel: selectedStation?.trafficStatus ?? TrafficLevel.normal,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Gap(AppSize.s8),
              Skeletonizer(
                enabled: state.todayReportsStatus != TodayReportsStatus.loading ? false : true,
                effect: baseEfect(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppPadding.p8,
                    horizontal: AppPadding.p12,
                  ),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFEEF9F7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppSize.s16),
                        topRight: Radius.circular(AppSize.s6),
                        bottomLeft: Radius.circular(AppSize.s16),
                        bottomRight: Radius.circular(AppSize.s16),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppAssets.doublePeson,
                        width: AppSize.s68,
                        height: AppSize.s45,
                      ),
                      const Gap(AppSize.s12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "$reportsCount",
                                style: AppStyles.getBold(
                                  context: context,
                                  color: const Color(0xFF11201F),
                                  fontSize: AppSize.s13,
                                ),
                              ),
                              const Gap(AppSize.s4),
                              Text(
                                appContext.localText.user_report_station,
                                style: AppStyles.getBold(
                                  context: context,
                                  color: const Color(0xFF11201F),
                                  fontSize: AppSize.s13,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                latestReport != null ? 'آخرها قبل' : 'لا توجد مشاهدات',
                                style: AppStyles.getMeduim(
                                  context: context,
                                  color: const Color(0xFF4A5957),
                                  fontSize: AppSize.s12,
                                ),
                              ),
                              const Gap(AppSize.s3),
                              Text(
                                latestReport != null
                                    ? latestReport.createdAtRelativeText.replaceFirst('منذ ', '')
                                    : 'لهذا اليوم',
                                style: AppStyles.getMeduim(
                                  context: context,
                                  color: const Color(0xFF4A5957),
                                  fontSize: AppSize.s12,
                                ),
                              ),
                              const Gap(AppSize.s3),
                              Text(
                                latestReport != null ? ': ${latestReport.queueStatus.arabicLabel}' : '',
                                style: AppStyles.getMeduim(
                                  context: context,
                                  color: const Color(0xFF4A5957),
                                  fontSize: AppSize.s12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(AppSize.s10),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Skeletonizer(
                      enabled:
                          state.historyStatus == StationHistoryStatus.loading ||
                          state.todayReportsStatus == TodayReportsStatus.loading,
                      effect: baseEfect(),
                      child: SizedBox(
                        height: AppSize.s48,
                        child: Container(
                          decoration:
                              state.historyStatus == StationHistoryStatus.loading ||
                                  state.todayReportsStatus == TodayReportsStatus.loading
                              ? null
                              : const BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFF0F6E67),
                                      blurRadius: 18,
                                      offset: Offset(0, 8),
                                      spreadRadius: -10,
                                    ),
                                  ],
                                ),
                          child: ElevatedButton(
                            style:
                                state.historyStatus == StationHistoryStatus.loading ||
                                    state.todayReportsStatus == TodayReportsStatus.loading
                                ? null
                                : ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0F6E67),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                            onPressed: onViewDetailsPressed ?? () {},
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                appContext.localText.view_details_and_hitory_station,
                                maxLines: 1,
                                style: AppStyles.getBold(
                                  context: context,
                                  color: Colors.white,
                                  fontSize: AppSize.s15,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Gap(AppSize.s8),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                        backgroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: AppColors.border,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: onOpenRoutePressed ?? () {},
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          children: [
                            const Gap(AppSize.s8),
                            SvgPicture.asset(
                              AppAssets.trackLocation,
                              colorFilter: const ColorFilter.mode(
                                Color(0XFF083A38),
                                BlendMode.srcIn,
                              ),
                              width: AppSize.s19,
                              height: AppSize.s19,
                            ),
                            const Gap(AppSize.s8),
                            Text(
                              appContext.localText.open_route,
                              maxLines: 1,
                              style: AppStyles.getBold(
                                context: context,
                                color: const Color(0xFF083A38),
                                fontSize: AppSize.s15,
                              ),
                            ),
                            const Gap(AppSize.s5),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ShimmerEffect baseEfect() {
    return ShimmerEffect(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      duration: const Duration(milliseconds: 1500),
    );
  }
}
