import 'package:equatable/equatable.dart';
import 'package:fuelsense/features/stations/domain/extensions/station_extensions.dart';

import '../../../../core/domain/models/failure.dart';
import '../../domain/entities/field_report_entity.dart';
import '../../domain/entities/station_entity.dart';
import '../../domain/entities/station_history_entity.dart';
import '../../domain/entities/station_insights_entity.dart';
import '../../domain/enums/station_enums.dart';

class StationsState extends Equatable {
  final StationsDataStatus stationsStatus;
  final TodayReportsStatus todayReportsStatus;
  final StationHistoryStatus historyStatus;
  final HistorySessionReportsStatus historySessionReportsStatus;
  final SubmitReportStatus submitReportStatus;
  final ConfirmReportStatus confirmReportStatus;
  final FavoriteActionStatus favoriteActionStatus;

  final List<StationEntity> allStations;
  final List<StationEntity> filteredStations;
  final StationEntity? selectedStation;

  final StationQuickFilter activeQuickFilter;
  final String? selectedCityFilter;
  final String searchQuery;

  final List<FieldReportEntity> todayReports;
  final List<int> confirmedReportIds;

  final List<StationHistoryEntity> stationHistory;
  final StationBehaviorInsightsEntity? behaviorInsights;
  final int? expandedHistoryId;
  final Map<int, List<FieldReportEntity>> historyReportsBySessionId;

  final List<int> favoriteStationIds;

  final double? currentDistanceToSelectedStationMeters;
  final bool isUserWithinSelectedStationRange;

  final Failure? failure;

  const StationsState({
    this.stationsStatus = StationsDataStatus.initial,
    this.todayReportsStatus = TodayReportsStatus.initial,
    this.historyStatus = StationHistoryStatus.initial,
    this.historySessionReportsStatus = HistorySessionReportsStatus.initial,
    this.submitReportStatus = SubmitReportStatus.idle,
    this.confirmReportStatus = ConfirmReportStatus.idle,
    this.favoriteActionStatus = FavoriteActionStatus.idle,
    this.allStations = const [],
    this.filteredStations = const [],
    this.selectedStation,
    this.activeQuickFilter = StationQuickFilter.all,
    this.selectedCityFilter,
    this.searchQuery = '',
    this.todayReports = const [],
    this.confirmedReportIds = const [],
    this.stationHistory = const [],
    this.behaviorInsights,
    this.expandedHistoryId,
    this.historyReportsBySessionId = const {},
    this.favoriteStationIds = const [],
    this.currentDistanceToSelectedStationMeters,
    this.isUserWithinSelectedStationRange = false,
    this.failure,
  });

  StationsSummaryCountsEntity get summaryCounts => StationsSummaryCountsEntity.fromStations(
    selectedCityFilter == null ? allStations : allStations.where((s) => s.city == selectedCityFilter).toList(),
  );

  bool get isSelectedStationFavorite => selectedStation != null && favoriteStationIds.contains(selectedStation!.id);

  String get todayFieldSummaryText {
    if (todayReports.isEmpty) {
      return 'لا توجد آراء اليوم';
    }
    final latest = todayReports.first;
    return '${todayReports.length} آراء موثقة من المتواجدين اليوم (آخرها ${latest.createdAtRelativeText}: ${latest.queueStatus.arabicLabel})';
  }

  StationsState copyWith({
    StationsDataStatus? stationsStatus,
    TodayReportsStatus? todayReportsStatus,
    StationHistoryStatus? historyStatus,
    HistorySessionReportsStatus? historySessionReportsStatus,
    SubmitReportStatus? submitReportStatus,
    ConfirmReportStatus? confirmReportStatus,
    FavoriteActionStatus? favoriteActionStatus,
    List<StationEntity>? allStations,
    List<StationEntity>? filteredStations,
    StationEntity? selectedStation,
    bool clearSelectedStation = false,
    StationQuickFilter? activeQuickFilter,
    String? selectedCityFilter,
    bool clearCityFilter = false,
    String? searchQuery,
    List<FieldReportEntity>? todayReports,
    List<int>? confirmedReportIds,
    List<StationHistoryEntity>? stationHistory,
    StationBehaviorInsightsEntity? behaviorInsights,
    int? expandedHistoryId,
    bool clearExpandedHistoryId = false,
    Map<int, List<FieldReportEntity>>? historyReportsBySessionId,
    List<int>? favoriteStationIds,
    double? currentDistanceToSelectedStationMeters,
    bool? isUserWithinSelectedStationRange,
    Failure? failure,
  }) {
    return StationsState(
      stationsStatus: stationsStatus ?? this.stationsStatus,
      todayReportsStatus: todayReportsStatus ?? this.todayReportsStatus,
      historyStatus: historyStatus ?? this.historyStatus,
      historySessionReportsStatus: historySessionReportsStatus ?? this.historySessionReportsStatus,
      submitReportStatus: submitReportStatus ?? this.submitReportStatus,
      confirmReportStatus: confirmReportStatus ?? this.confirmReportStatus,
      favoriteActionStatus: favoriteActionStatus ?? this.favoriteActionStatus,
      allStations: allStations ?? this.allStations,
      filteredStations: filteredStations ?? this.filteredStations,
      selectedStation: clearSelectedStation ? null : (selectedStation ?? this.selectedStation),
      activeQuickFilter: activeQuickFilter ?? this.activeQuickFilter,
      selectedCityFilter: clearCityFilter ? null : (selectedCityFilter ?? this.selectedCityFilter),
      searchQuery: searchQuery ?? this.searchQuery,
      todayReports: todayReports ?? this.todayReports,
      confirmedReportIds: confirmedReportIds ?? this.confirmedReportIds,
      stationHistory: stationHistory ?? this.stationHistory,
      behaviorInsights: behaviorInsights ?? this.behaviorInsights,
      expandedHistoryId: clearExpandedHistoryId ? null : (expandedHistoryId ?? this.expandedHistoryId),
      historyReportsBySessionId: historyReportsBySessionId ?? this.historyReportsBySessionId,
      favoriteStationIds: favoriteStationIds ?? this.favoriteStationIds,
      currentDistanceToSelectedStationMeters:
          currentDistanceToSelectedStationMeters ?? this.currentDistanceToSelectedStationMeters,
      isUserWithinSelectedStationRange: isUserWithinSelectedStationRange ?? this.isUserWithinSelectedStationRange,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [
    stationsStatus,
    todayReportsStatus,
    historyStatus,
    historySessionReportsStatus,
    submitReportStatus,
    confirmReportStatus,
    favoriteActionStatus,
    allStations,
    filteredStations,
    selectedStation,
    activeQuickFilter,
    selectedCityFilter,
    searchQuery,
    todayReports,
    confirmedReportIds,
    stationHistory,
    behaviorInsights,
    expandedHistoryId,
    historyReportsBySessionId,
    favoriteStationIds,
    currentDistanceToSelectedStationMeters,
    isUserWithinSelectedStationRange,
    failure,
  ];
  @override
  bool get stringify => false;

  @override
  String toString() {
    return 'StationsState('
        'stations: $stationsStatus, '
        'todayReports: $todayReportsStatus, '
        'history: $historyStatus, '
        'allStations: [List: ${allStations.length}], '
        'filtered: [List: ${filteredStations.length}], '
        'selected: ${selectedStation != null ? "[StationEntity #${selectedStation!.id}]" : "null"}, '
        'reportsList: [List: ${todayReports.length}], '
        'historyList: [List: ${stationHistory.length}], '
        'insights: ${behaviorInsights != null ? "[Loaded]" : "null"}'
        ')';
  }
}
