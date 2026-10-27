import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuelsense/features/stations/domain/repositories/stations_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/entities/field_report_entity.dart';
import '../../domain/entities/station_entity.dart';
import '../../domain/entities/station_insights_entity.dart';
import '../../domain/enums/station_enums.dart';
import '../../domain/extensions/station_extensions.dart';
import '../../domain/use_case/stations_use_cases.dart';
import 'stations_event.dart';
import 'stations_state.dart';

@lazySingleton
class StationsBloc extends Bloc<StationsEvent, StationsState> {
  StreamSubscription? _stationsSub;
  StreamSubscription? _todayReportsSub;

  final WatchStationsUseCase _watchStationsUseCase;
  final WatchTodayReportsUseCase _watchTodayReportsUseCase;
  final GetStationHistoryUseCase _getStationHistoryUseCase;
  final GetHistoryReportsUseCase _getHistoryReportsUseCase;
  final SubmitFieldReportUseCase _submitFieldReportUseCase;
  final ConfirmFieldReportUseCase _confirmFieldReportUseCase;
  final GetUserConfirmedReportIdsUseCase _getUserConfirmedReportIdsUseCase;
  final GetFavoriteStationIdsUseCase _getFavoriteStationIdsUseCase;
  final ToggleFavoriteStationUseCase _toggleFavoriteStationUseCase;

  StationsBloc({
    required this._watchStationsUseCase,
    required this._watchTodayReportsUseCase,
    required this._getStationHistoryUseCase,
    required this._getHistoryReportsUseCase,
    required this._submitFieldReportUseCase,
    required this._confirmFieldReportUseCase,
    required this._getUserConfirmedReportIdsUseCase,
    required this._getFavoriteStationIdsUseCase,
    required this._toggleFavoriteStationUseCase,
  }) : super(const StationsState()) {
    on<WatchStationsEvent>(_onWatchStations);
    on<UpdateStationsListEvent>(_onUpdateStationsList);
    on<StationsStreamErrorEvent>(_onStationsStreamError);
    on<ChangeQuickFilterEvent>(_onChangeQuickFilter);
    on<ChangeCityFilterEvent>(_onChangeCityFilter);
    on<SearchStationsEvent>(
      _onSearchStations,
      transformer: _debounce(const Duration(milliseconds: 500)),
    );

    on<SelectStationEvent>(_onSelectStation);
    on<UpdateTodayReportsEvent>(_onUpdateTodayReports);
    on<TodayReportsStreamErrorEvent>(_onTodayReportsStreamError);

    on<LoadStationHistoryEvent>(_onLoadStationHistory);
    on<ToggleHistorySessionExpansionEvent>(_onToggleHistorySessionExpansion);

    on<CheckUserGeofenceEvent>(_onCheckUserGeofence);
    on<SubmitFieldReportEvent>(_onSubmitFieldReport);
    on<ConfirmFieldReportEvent>(_onConfirmFieldReport);

    on<LoadFavoriteStationsEvent>(_onLoadFavoriteStations);
    on<ToggleFavoriteStationEvent>(_onToggleFavoriteStation);
  }

  void _onWatchStations(WatchStationsEvent event, Emitter<StationsState> emit) {
    if (_stationsSub != null) return;

    if (state.allStations.isEmpty) {
      emit(state.copyWith(stationsStatus: StationsDataStatus.loading));
    }

    add(LoadFavoriteStationsEvent());

    _stationsSub = _watchStationsUseCase.call().listen((either) {
      either.fold(
        (failure) {
          _stationsSub?.cancel();
          _stationsSub = null;
          add(StationsStreamErrorEvent(failure));
        },
        (stations) {
          add(UpdateStationsListEvent(stations: stations));
        },
      );
    });
  }

  void _onUpdateStationsList(
    UpdateStationsListEvent event,
    Emitter<StationsState> emit,
  ) {
    final filtered = _applyFilters(
      stations: event.stations,
      quickFilter: state.activeQuickFilter,
      cityFilter: state.selectedCityFilter,
      query: state.searchQuery,
    );

    StationEntity? updatedSelected = state.selectedStation;
    if (updatedSelected != null) {
      for (final st in event.stations) {
        if (st.id == updatedSelected?.id) {
          updatedSelected = st;
          break;
        }
      }
    } else if (filtered.isNotEmpty) {
      updatedSelected = filtered.first;
    }

    emit(
      state.copyWith(
        allStations: event.stations,
        filteredStations: filtered,
        selectedStation: updatedSelected,
        stationsStatus: filtered.isEmpty ? StationsDataStatus.empty : StationsDataStatus.loaded,
      ),
    );
  }

  void _onStationsStreamError(
    StationsStreamErrorEvent event,
    Emitter<StationsState> emit,
  ) {
    emit(
      state.copyWith(
        failure: event.error,
        stationsStatus: state.allStations.isNotEmpty ? StationsDataStatus.loaded : StationsDataStatus.error,
      ),
    );
  }

  void _onChangeQuickFilter(
    ChangeQuickFilterEvent event,
    Emitter<StationsState> emit,
  ) {
    final filtered = _applyFilters(
      stations: state.allStations,
      quickFilter: event.filter,
      cityFilter: state.selectedCityFilter,
      query: state.searchQuery,
    );
    emit(
      state.copyWith(
        activeQuickFilter: event.filter,
        filteredStations: filtered,
        stationsStatus: filtered.isEmpty ? StationsDataStatus.empty : StationsDataStatus.loaded,
      ),
    );
  }

  void _onChangeCityFilter(
    ChangeCityFilterEvent event,
    Emitter<StationsState> emit,
  ) {
    final filtered = _applyFilters(
      stations: state.allStations,
      quickFilter: state.activeQuickFilter,
      cityFilter: event.city,
      query: state.searchQuery,
    );
    emit(
      state.copyWith(
        selectedCityFilter: event.city,
        clearCityFilter: event.city == null,
        filteredStations: filtered,
        stationsStatus: filtered.isEmpty ? StationsDataStatus.empty : StationsDataStatus.loaded,
      ),
    );
  }

  EventTransformer<T> _debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
  }

  void _onSearchStations(
    SearchStationsEvent event,
    Emitter<StationsState> emit,
  ) {
    emit(
      state.copyWith(
        activeQuickFilter: StationQuickFilter.all,
        filteredStations: state.allStations,
      ),
    );
    final filtered = _applyFilters(
      stations: state.allStations,
      quickFilter: state.activeQuickFilter,
      cityFilter: state.selectedCityFilter,
      query: event.query,
    );
    emit(
      state.copyWith(
        searchQuery: event.query,
        filteredStations: filtered,
        stationsStatus: filtered.isEmpty ? StationsDataStatus.empty : StationsDataStatus.loaded,
      ),
    );
  }

  List<StationEntity> _applyFilters({
    required List<StationEntity> stations,
    required StationQuickFilter quickFilter,
    required String? cityFilter,
    required String query,
  }) {
    return stations.where((station) {
      if (cityFilter != null && cityFilter.isNotEmpty && station.city != cityFilter) {
        return false;
      }

      switch (quickFilter) {
        case StationQuickFilter.all:
          break;
        case StationQuickFilter.openNow:
          if (station.status != OfficialStationStatus.open) return false;
          break;
        case StationQuickFilter.refilledToday:
          if (station.status != OfficialStationStatus.refilling) {
            return false;
          }
          break;
        case StationQuickFilter.onTheWay:
          if (station.status != OfficialStationStatus.onTheWay) return false;
          break;
        case StationQuickFilter.normalTraffic:
          if (station.trafficStatus != TrafficLevel.normal) return false;
          break;
      }

      if (query.trim().isNotEmpty) {
        final q = query.trim();
        final matchesName = station.name.contains(q);
        final matchesCity = station.city.contains(q);
        final matchesAlias = station.aliases?.contains(q) ?? false;
        if (!matchesName && !matchesCity && !matchesAlias) return false;
      }

      return true;
    }).toList();
  }

  Future<void> _onSelectStation(
    SelectStationEvent event,
    Emitter<StationsState> emit,
  ) async {
    double? distance;
    bool withinRange = false;

    if (event.userLatitude != null && event.userLongitude != null) {
      distance = StationGeoAndTimeUtils.calculateDistanceMeters(
        userLat: event.userLatitude!,
        userLng: event.userLongitude!,
        stationLat: event.station.latitude,
        stationLng: event.station.longitude,
      );
      withinRange = distance <= StationGeoAndTimeUtils.maxAllowedDistanceMeters;
    }

    emit(
      state.copyWith(
        selectedStation: event.station,
        todayReportsStatus: TodayReportsStatus.loading,
        todayReports: const [],
        currentDistanceToSelectedStationMeters: distance,
        isUserWithinSelectedStationRange: withinRange,
        clearExpandedHistoryId: true,
      ),
    );

    add(LoadStationHistoryEvent(event.station.id));

    final oldSub = _todayReportsSub;
    _todayReportsSub = null;
    oldSub?.cancel();

    final int targetStationId = event.station.id;
    _todayReportsSub = _watchTodayReportsUseCase.call(targetStationId).listen(
      (either) {
        if (state.selectedStation?.id != targetStationId) return;
        either.fold(
          (failure) {
            add(TodayReportsStreamErrorEvent(failure));
          },
          (reports) {
            add(UpdateTodayReportsEvent(reports: reports));
          },
        );
      },
    );

    final confirmedRes = await _getUserConfirmedReportIdsUseCase.call(targetStationId);
    if (state.selectedStation?.id == targetStationId && !emit.isDone) {
      confirmedRes.fold(
        (_) {},
        (ids) => emit(state.copyWith(confirmedReportIds: ids)),
      );
    }
  }

  void _onUpdateTodayReports(
    UpdateTodayReportsEvent event,
    Emitter<StationsState> emit,
  ) {
    emit(
      state.copyWith(
        todayReports: event.reports,
        todayReportsStatus: event.reports.isEmpty ? TodayReportsStatus.empty : TodayReportsStatus.loaded,
      ),
    );
  }

  void _onTodayReportsStreamError(
    TodayReportsStreamErrorEvent event,
    Emitter<StationsState> emit,
  ) {
    emit(
      state.copyWith(
        failure: event.error,
        todayReportsStatus: state.todayReports.isNotEmpty ? TodayReportsStatus.loaded : TodayReportsStatus.error,
      ),
    );
  }

  Future<void> _onLoadStationHistory(
    LoadStationHistoryEvent event,
    Emitter<StationsState> emit,
  ) async {
    emit(state.copyWith(historyStatus: StationHistoryStatus.loading));

    final result = await _getStationHistoryUseCase.call(event.stationId);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            failure: failure,
            historyStatus: StationHistoryStatus.error,
          ),
        );
      },
      (historyList) {
        final insights = StationBehaviorInsightsEntity.fromHistoryList(historyList);
        emit(
          state.copyWith(
            stationHistory: historyList,
            behaviorInsights: insights,
            expandedHistoryId: historyList.isNotEmpty ? historyList.first.id : null,
            historyStatus: historyList.isEmpty ? StationHistoryStatus.empty : StationHistoryStatus.loaded,
          ),
        );
      },
    );
  }

  Future<void> _onToggleHistorySessionExpansion(
    ToggleHistorySessionExpansionEvent event,
    Emitter<StationsState> emit,
  ) async {
    if (state.expandedHistoryId == event.historyId) {
      emit(state.copyWith(clearExpandedHistoryId: true));
      return;
    }

    emit(
      state.copyWith(
        expandedHistoryId: event.historyId,
        historySessionReportsStatus: HistorySessionReportsStatus.loading,
      ),
    );

    if (state.historyReportsBySessionId.containsKey(event.historyId)) {
      emit(state.copyWith(historySessionReportsStatus: HistorySessionReportsStatus.loaded));
      return;
    }

    final result = await _getHistoryReportsUseCase.call(event.historyId);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            failure: failure,
            historySessionReportsStatus: HistorySessionReportsStatus.error,
          ),
        );
      },
      (reports) {
        final updatedMap = Map<int, List<FieldReportEntity>>.from(state.historyReportsBySessionId);
        updatedMap[event.historyId] = reports;
        emit(
          state.copyWith(
            historyReportsBySessionId: updatedMap,
            historySessionReportsStatus: HistorySessionReportsStatus.loaded,
          ),
        );
      },
    );
  }

  void _onCheckUserGeofence(
    CheckUserGeofenceEvent event,
    Emitter<StationsState> emit,
  ) {
    final station = state.selectedStation;
    if (station == null) return;

    final distance = StationGeoAndTimeUtils.calculateDistanceMeters(
      userLat: event.userLatitude,
      userLng: event.userLongitude,
      stationLat: station.latitude,
      stationLng: station.longitude,
    );

    emit(
      state.copyWith(
        currentDistanceToSelectedStationMeters: distance,
        isUserWithinSelectedStationRange: distance <= StationGeoAndTimeUtils.maxAllowedDistanceMeters,
      ),
    );
  }

  Future<void> _onSubmitFieldReport(
    SubmitFieldReportEvent event,
    Emitter<StationsState> emit,
  ) async {
    final station = state.selectedStation;
    if (station == null) return;

    final distance = StationGeoAndTimeUtils.calculateDistanceMeters(
      userLat: event.userLatitude,
      userLng: event.userLongitude,
      stationLat: station.latitude,
      stationLng: station.longitude,
    );

    if (distance > StationGeoAndTimeUtils.maxAllowedDistanceMeters) {
      emit(
        state.copyWith(
          currentDistanceToSelectedStationMeters: distance,
          isUserWithinSelectedStationRange: false,
          submitReportStatus: SubmitReportStatus.outOfRangeError,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        currentDistanceToSelectedStationMeters: distance,
        isUserWithinSelectedStationRange: true,
        submitReportStatus: SubmitReportStatus.submitting,
      ),
    );

    final result = await _submitFieldReportUseCase.call(
      SubmitFieldReportParams(
        stationId: station.id,
        stationName: station.name,
        stationCity: station.city,
        queueStatus: event.queueStatus,
        note: event.note,
        userLatitude: event.userLatitude,
        userLongitude: event.userLongitude,
        distanceToStation: distance,
        isCameraVerified: event.isCameraVerified,
        aiConfidence: event.aiConfidence,
        aiInferenceMs: event.aiInferenceMs,
      ),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            failure: failure,
            submitReportStatus: SubmitReportStatus.error,
          ),
        );
      },
      (_) {
        emit(state.copyWith(submitReportStatus: SubmitReportStatus.success));
      },
    );
  }

  Future<void> _onConfirmFieldReport(
    ConfirmFieldReportEvent event,
    Emitter<StationsState> emit,
  ) async {
    final station = state.selectedStation;
    if (station == null) return;

    if (state.confirmedReportIds.contains(event.reportId)) return;

    final distance = StationGeoAndTimeUtils.calculateDistanceMeters(
      userLat: event.userLatitude,
      userLng: event.userLongitude,
      stationLat: station.latitude,
      stationLng: station.longitude,
    );

    if (distance > StationGeoAndTimeUtils.maxAllowedDistanceMeters) {
      emit(
        state.copyWith(
          currentDistanceToSelectedStationMeters: distance,
          isUserWithinSelectedStationRange: false,
          confirmReportStatus: ConfirmReportStatus.outOfRangeError,
        ),
      );
      return;
    }

    emit(state.copyWith(confirmReportStatus: ConfirmReportStatus.confirming));

    final updatedReports = state.todayReports.map((r) {
      if (r.id == event.reportId) {
        return r.copyWith(
          confirmationsCount: r.confirmationsCount + 1,
          lastConfirmedAt: DateTime.now(),
        );
      }
      return r;
    }).toList();

    final updatedConfirmedIds = List<int>.from(state.confirmedReportIds)..add(event.reportId);

    emit(
      state.copyWith(
        todayReports: updatedReports,
        confirmedReportIds: updatedConfirmedIds,
      ),
    );

    final result = await _confirmFieldReportUseCase.call(
      ConfirmFieldReportParams(
        reportId: event.reportId,
        userLatitude: event.userLatitude,
        userLongitude: event.userLongitude,
        distanceToStation: distance,
      ),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            failure: failure,
            confirmReportStatus: ConfirmReportStatus.error,
          ),
        );
      },
      (_) {
        emit(state.copyWith(confirmReportStatus: ConfirmReportStatus.success));
      },
    );
  }

  Future<void> _onLoadFavoriteStations(
    LoadFavoriteStationsEvent event,
    Emitter<StationsState> emit,
  ) async {
    final result = await _getFavoriteStationIdsUseCase.call();
    result.fold(
      (_) {},
      (ids) => emit(state.copyWith(favoriteStationIds: ids)),
    );
  }

  Future<void> _onToggleFavoriteStation(
    ToggleFavoriteStationEvent event,
    Emitter<StationsState> emit,
  ) async {
    emit(state.copyWith(favoriteActionStatus: FavoriteActionStatus.loading));

    final currentFavs = List<int>.from(state.favoriteStationIds);
    if (currentFavs.contains(event.stationId)) {
      currentFavs.remove(event.stationId);
    } else {
      currentFavs.add(event.stationId);
    }
    emit(state.copyWith(favoriteStationIds: currentFavs));

    final result = await _toggleFavoriteStationUseCase.call(event.stationId);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            failure: failure,
            favoriteActionStatus: FavoriteActionStatus.error,
          ),
        );
      },
      (_) {
        emit(state.copyWith(favoriteActionStatus: FavoriteActionStatus.success));
      },
    );
  }

  @override
  Future<void> close() {
    _stationsSub?.cancel();
    _todayReportsSub?.cancel();
    return super.close();
  }
}
