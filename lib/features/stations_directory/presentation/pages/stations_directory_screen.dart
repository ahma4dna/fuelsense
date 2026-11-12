import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuelsense/core/application/resource/app_colors.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:fuelsense/core/widget/smooth_animations.dart';
import 'package:fuelsense/di/injection.dart';

import 'package:fuelsense/features/stations_directory/presentation/widgets/filters/status_filter_bottom_sheet.dart';
import 'package:fuelsense/features/stations_directory/presentation/widgets/header/directory_header_section.dart';
import 'package:fuelsense/features/stations_directory/presentation/widgets/loading/skeleton_list.dart';
import 'package:fuelsense/features/stations_directory/presentation/widgets/sorting/smart_sort_chips_bar.dart';
import 'package:fuelsense/features/stations_directory/presentation/widgets/station_card/station_directory_card.dart';
import 'package:gap/gap.dart';

import '../../domain/entities/station_directory_entity.dart';
import '../bloc/stations_directory_bloc.dart';
import '../bloc/stations_directory_event.dart';
import '../bloc/stations_directory_state.dart';

class StationsDirectoryScreen extends StatefulWidget {
  final ValueChanged<StationDirectoryEntity>? onStationTap;

  const StationsDirectoryScreen({
    super.key,
    this.onStationTap,
  });

  @override
  State<StationsDirectoryScreen> createState() => _StationsDirectoryScreenState();
}

class _StationsDirectoryScreenState extends State<StationsDirectoryScreen> {
  late final StationsDirectoryBloc _bloc;

  bool _entranceDone = false;
  Timer? _entranceTimer;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<StationsDirectoryBloc>()..add(const LoadStationsDirectoryEvent());
  }

  @override
  void dispose() {
    _entranceTimer?.cancel();
    _bloc.close();
    super.dispose();
  }

  void _showStatusFilterSheet(
    BuildContext context,
    StationsDirectoryState state,
  ) {
    HapticFeedback.selectionClick();
    StatusFilterBottomSheet.show(
      context: context,
      selectedFilter: state.statusFilter,
      onFilterSelected: (filter) {
        _bloc.add(SelectStatusFilterEvent(filter));
      },
    );
  }

  void _armEntranceTimer() {
    _entranceTimer ??= Timer(const Duration(milliseconds: 1500), () {
      _entranceDone = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appContext = AppContext.of(context);

    return BlocProvider.value(
      value: _bloc,
      child: BlocBuilder<StationsDirectoryBloc, StationsDirectoryState>(
        builder: (context, state) {
          if (!state.isLoading) _armEntranceTimer();

          return Directionality(
            textDirection: appContext.isRt ? TextDirection.rtl : TextDirection.ltr,
            child: Scaffold(
              backgroundColor: const Color(0xFFF6F4EE),
              body: Column(
                children: [
                  FadeSlide(
                    dy: -24,
                    duration: const Duration(milliseconds: 650),
                    child: DirectoryHeaderSection(
                      cityLabel: state.cityHeaderLabel,
                      openCount: state.openCount,
                      refillingCount: state.refillingCount,
                      onTheWayCount: state.onTheWayCount,
                      closedCount: state.closedCount,
                      activeFilter: state.statusFilter,
                      onFilterButtonTap: () => _showStatusFilterSheet(context, state),
                      onStatusCounterTap: (filter) {
                        HapticFeedback.selectionClick();
                        _bloc.add(SelectStatusFilterEvent(filter));
                      },
                    ),
                  ),
                  FadeSlide(
                    delay: const Duration(milliseconds: 150),
                    dy: 16,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppPadding.p16,
                        AppPadding.p16,
                        AppPadding.p16,
                        AppPadding.p12,
                      ),
                      child: SmartSortChipsBar(
                        selectedSort: state.sortOption,
                        onSortChanged: (option) {
                          HapticFeedback.selectionClick();
                          _bloc.add(SelectSortOptionEvent(option));
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 450),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      child: state.isLoading
                          ? const SkeletonList(key: ValueKey('skeleton'))
                          : KeyedSubtree(
                              key: const ValueKey('content'),
                              child: _buildContent(context, state, appContext),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    StationsDirectoryState state,
    AppContext appContext,
  ) {
    return RefreshIndicator(
      color: const Color(0xFF0F6E67),
      backgroundColor: AppColors.white,
      onRefresh: () async {
        HapticFeedback.lightImpact();
        _bloc.add(
          const LoadStationsDirectoryEvent(
            showLoading: false,
          ),
        );
        await Future<void>.delayed(const Duration(milliseconds: 700));
      },
      child: state.displayedStations.isEmpty
          ? ListView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              padding: const EdgeInsets.all(AppPadding.p32),
              children: [
                const Gap(AppSize.s48),
                const FadeSlide(
                  dy: 12,
                  scaleFrom: 0.7,
                  curve: Curves.easeOutBack,
                  child: Icon(
                    Icons.local_gas_station_outlined,
                    size: AppSize.s54,
                    color: Color(0xFF8C9896),
                  ),
                ),
                const Gap(AppSize.s14),
                FadeSlide(
                  delay: const Duration(milliseconds: 150),
                  dy: 12,
                  child: Text(
                    appContext.localText.empty_filtered_stations,
                    textAlign: TextAlign.center,
                    style: AppStyles.getBold(
                      context: context,
                      fontSize: AppSize.s16,
                      color: const Color(0xFF5A6866),
                    ),
                  ),
                ),
              ],
            )
          : ListView.separated(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              padding: const EdgeInsets.fromLTRB(
                AppPadding.p16,
                AppPadding.p4,
                AppPadding.p16,
                AppPadding.p24,
              ),
              itemCount: state.displayedStations.length,
              separatorBuilder: (_, _) => const Gap(AppSize.s14),
              itemBuilder: (context, index) {
                final station = state.displayedStations[index];
                final card = PressScale(
                  child: StationDirectoryCard(
                    station: station,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      widget.onStationTap?.call(station);
                    },
                  ),
                );

                if (_entranceDone || index > 7) return card;
                return FadeSlide(
                  delay: Duration(milliseconds: 120 + index * 70),
                  dy: 32,
                  scaleFrom: 0.96,
                  duration: const Duration(milliseconds: 600),
                  child: card,
                );
              },
            ),
    );
  }
}
