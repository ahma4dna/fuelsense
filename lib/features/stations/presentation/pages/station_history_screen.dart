import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/di/injection.dart';
import 'package:fuelsense/features/stations/domain/entities/station_entity.dart';
import 'package:fuelsense/features/stations/presentation/bloc/stations_bloc.dart';
import 'package:fuelsense/features/stations/presentation/bloc/stations_event.dart';
import 'package:fuelsense/features/stations/presentation/bloc/stations_state.dart';
import 'package:fuelsense/features/stations/presentation/widgets/station_details_widget/header_sation_history.dart';
import 'package:fuelsense/features/stations/presentation/widgets/station_details_widget/list_report_today.dart';
import 'package:fuelsense/features/stations/presentation/widgets/station_details_widget/station_history_state_widget.dart';
import 'package:fuelsense/features/stations/presentation/widgets/station_details_widget/station_history_tific_route.dart';
import 'package:fuelsense/features/stations/presentation/widgets/station_details_widget/station_time_line_list_widget.dart';
import 'package:fuelsense/features/stations/presentation/widgets/station_details_widget/tab_bar_station_history_widget.dart';
import 'package:gap/gap.dart';

class StationHistoryScreen extends StatefulWidget {
  final StationEntity stationEntity;
  const StationHistoryScreen({super.key, required this.stationEntity});

  @override
  State<StationHistoryScreen> createState() => _StationHistoryScreenState();
}

class _StationHistoryScreenState extends State<StationHistoryScreen> {
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

          return Scaffold(
            body: Column(
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
                    appContext: appContext,
                    stationEntity: currentStation,
                  ),
                ),
                const Gap(AppSize.s12),
                StationHistoryTificRoute(
                  appContext: appContext,
                  stationEntity: currentStation,
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
          );
        },
      ),
    );
  }
}
