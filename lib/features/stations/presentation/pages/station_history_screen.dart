import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuelsense/core/application/resource/app_colors.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:fuelsense/di/injection.dart';
import 'package:fuelsense/features/stations/domain/entities/station_entity.dart';
import 'package:fuelsense/features/stations/domain/enums/station_enums.dart';
import 'package:fuelsense/features/stations/presentation/bloc/stations_bloc.dart';
import 'package:fuelsense/features/stations/presentation/bloc/stations_event.dart';
import 'package:fuelsense/features/stations/presentation/bloc/stations_state.dart';
import 'package:fuelsense/features/stations/presentation/routes/stations_path.dart';
import 'package:fuelsense/features/stations/presentation/widgets/station_details_widget/delay_percentage_badge.dart';
import 'package:fuelsense/features/stations/presentation/widgets/station_details_widget/header_sation_history.dart';
import 'package:fuelsense/features/stations/presentation/widgets/station_details_widget/list_report_today.dart';
import 'package:fuelsense/features/stations/presentation/widgets/station_details_widget/station_history_state_widget.dart';
import 'package:fuelsense/features/stations/presentation/widgets/station_details_widget/station_time_line_list_widget.dart';
import 'package:fuelsense/features/stations/presentation/widgets/station_details_widget/tab_bar_station_history_widget.dart';
import 'package:fuelsense/features/stations/presentation/widgets/station_details_widget/three_segment_traffic_gauge.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class StationHistoryScreen extends StatefulWidget {
  final StationEntity stationEntity;
  const StationHistoryScreen({super.key, required this.stationEntity});

  @override
  State<StationHistoryScreen> createState() => _StationHistoryScreenState();
}

class _StationHistoryScreenState extends State<StationHistoryScreen> {
  Color get _statusAccentColor {
    switch (widget.stationEntity.status) {
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
        return const Color(0xFF7B8886);
    }
  }

  int selectIndexTab = 0;

  @override
  Widget build(BuildContext context) {
    final appContext = AppContext.of(context);

    return BlocProvider.value(
      value: getIt<StationsBloc>(),
      child: BlocBuilder<StationsBloc, StationsState>(
        builder: (context, state) {
          final StationEntity currentStation =
              (state.selectedStation?.id == widget.stationEntity.id && state.selectedStation != null)
              ? state.selectedStation!
              : widget.stationEntity;
          String fullTraffic = currentStation.trafficDelayRatio > 0
              ? 'حالة الطريق: ${currentStation.trafficDescription} (+${currentStation.trafficDelayRatio}% تأخير)'
              : 'حالة الطريق: ${currentStation.trafficDescription}';

          return Scaffold(
            body: Stack(
              children: [
                Column(
                  children: [
                    SafeArea(
                      bottom: false,
                      child: HeaderSationHistory(
                        stationEntity: currentStation,
                      ),
                    ),
                    const Gap(AppSize.s12),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppPadding.p20,
                      ),
                      child: StationHistoryStateWidget(
                        color: _statusAccentColor,
                        appContext: appContext,
                        stationEntity: currentStation,
                      ),
                    ),
                    const Gap(AppSize.s12),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppPadding.p20,
                      ),
                      child: Container(
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
                                    trafficLevel: currentStation.trafficStatus,
                                  ),
                                ),
                                const Gap(AppSize.s12),
                                DelayPercentageBadge(
                                  delayPercentage: currentStation.trafficDelayRatio,
                                  trafficLevel: currentStation.trafficStatus,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(AppSize.s16),
                    TabBarStationHistoryWidget(
                      selectIndexTab: selectIndexTab,
                      todayReportsCount: state.todayReports.length,
                      onTapHitoryAndDate: () {
                        setState(() {
                          selectIndexTab = 1;
                        });
                      },
                      onTapTodayReportSelect: () {
                        setState(() {
                          selectIndexTab = 0;
                        });
                      },
                    ),
                    const Gap(AppSize.s12),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        transitionBuilder: (child, animation) {
                          final slideAnimation = Tween<Offset>(
                            begin: const Offset(0.05, 0.0),
                            end: Offset.zero,
                          ).animate(animation);

                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: slideAnimation,
                              child: child,
                            ),
                          );
                        },
                        child: selectIndexTab != 1
                            ? ListReportToday(
                                key: const ValueKey('today_report_list'),
                                appContext: appContext,
                                reports: state.todayReports,
                              )
                            : StationTimelineListWidget(
                                key: const ValueKey('station_history'),
                                historyEntities: state.stationHistory,
                                onItemToggled: (historyId) {
                                  getIt<StationsBloc>().add(
                                    ToggleHistorySessionExpansionEvent(historyId),
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                ),

                Positioned(
                  left: AppSize.s16,
                  right: AppSize.s16,
                  bottom: MediaQuery.paddingOf(context).bottom + 20,
                  child: SizedBox(
                    height: AppSize.s56,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.pushNamed(
                          addReportScreenName,
                          extra: (
                            currentStation.id,
                            currentStation.name,
                            currentStation.latitude,
                            currentStation.longitude,
                          ),
                        );
                      },
                      label: Text(
                        appContext.localText.add_statut_from_location,
                        style: AppStyles.getBold(
                          context: context,
                          fontSize: AppSize.s17,
                          color: AppColors.white,
                        ),
                      ),
                      icon: Icon(
                        Icons.add,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
