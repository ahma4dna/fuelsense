import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:fuelsense/di/injection.dart';
import 'package:fuelsense/features/stations_directory/presentation/widgets/filters/status_filter_bottom_sheet.dart';
import 'package:fuelsense/features/stations_directory/presentation/widgets/header/directory_header_section.dart';
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

  @override
  void initState() {
    super.initState();
    _bloc = getIt<StationsDirectoryBloc>()..add(const LoadStationsDirectoryEvent());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  void _showStatusFilterSheet(
    BuildContext context,
    StationsDirectoryState state,
  ) {
    StatusFilterBottomSheet.show(
      context: context,
      selectedFilter: state.statusFilter,
      onFilterSelected: (filter) {
        _bloc.add(SelectStatusFilterEvent(filter));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appContext = AppContext.of(context);

    return BlocProvider.value(
      value: _bloc,
      child: BlocBuilder<StationsDirectoryBloc, StationsDirectoryState>(
        builder: (context, state) {
          return Directionality(
            textDirection: appContext.isRt ? TextDirection.rtl : TextDirection.ltr,
            child: Scaffold(
              backgroundColor: const Color(0xFFF6F4EE),
              body: Column(
                children: [
                  DirectoryHeaderSection(
                    cityLabel: state.cityHeaderLabel,
                    openCount: state.openCount,
                    refillingCount: state.refillingCount,
                    onTheWayCount: state.onTheWayCount,
                    closedCount: state.closedCount,
                    activeFilter: state.statusFilter,
                    onFilterButtonTap: () => _showStatusFilterSheet(context, state),
                    onStatusCounterTap: (filter) => _bloc.add(SelectStatusFilterEvent(filter)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppPadding.p16,
                      AppPadding.p16,
                      AppPadding.p16,
                      AppPadding.p12,
                    ),
                    child: SmartSortChipsBar(
                      selectedSort: state.sortOption,
                      onSortChanged: (option) => _bloc.add(SelectSortOptionEvent(option)),
                    ),
                  ),
                  Expanded(
                    child: state.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF0F6E67),
                            ),
                          )
                        : RefreshIndicator(
                            color: const Color(0xFF0F6E67),
                            onRefresh: () async {
                              _bloc.add(
                                const LoadStationsDirectoryEvent(
                                  showLoading: false,
                                ),
                              );
                            },
                            child: state.displayedStations.isEmpty
                                ? ListView(
                                    padding: const EdgeInsets.all(AppPadding.p32),
                                    children: [
                                      const Gap(AppSize.s48),
                                      const Icon(
                                        Icons.local_gas_station_outlined,
                                        size: AppSize.s54,
                                        color: Color(0xFF8C9896),
                                      ),
                                      const Gap(AppSize.s14),
                                      Text(
                                        appContext.localText.empty_filtered_stations,
                                        textAlign: TextAlign.center,
                                        style: AppStyles.getBold(
                                          context: context,
                                          fontSize: AppSize.s16,
                                          color: const Color(0xFF5A6866),
                                        ),
                                      ),
                                    ],
                                  )
                                : ListView.separated(
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
                                      return StationDirectoryCard(
                                        station: station,
                                        onTap: () => widget.onStationTap?.call(station),
                                      );
                                    },
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
}
