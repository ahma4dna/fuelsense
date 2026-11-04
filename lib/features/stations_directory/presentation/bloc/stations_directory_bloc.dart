import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuelsense/features/stations_directory/domain/usecases/get_stations_directory_use_case.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/station_directory_entity.dart';
import '../../domain/enums/station_directory_enums.dart';
import 'stations_directory_event.dart';
import 'stations_directory_state.dart';

@injectable
class StationsDirectoryBloc extends Bloc<StationsDirectoryEvent, StationsDirectoryState> {
  final GetStationsDirectoryUseCase _getStationsDirectoryUseCase;
  StreamSubscription<void>? _realtimeSub;
  Position? _cachedPosition;

  StationsDirectoryBloc(this._getStationsDirectoryUseCase) : super(const StationsDirectoryState()) {
    on<LoadStationsDirectoryEvent>(_onLoadStations);
    on<SelectCityFilterEvent>(_onSelectCityFilter);
    on<SelectSortOptionEvent>(_onSelectSortOption);
    on<SelectStatusFilterEvent>(_onSelectStatusFilter);

    _realtimeSub = _getStationsDirectoryUseCase.watchChanges().listen((_) {
      add(const LoadStationsDirectoryEvent(showLoading: false));
    });
  }

  Future<void> _onLoadStations(
    LoadStationsDirectoryEvent event,
    Emitter<StationsDirectoryState> emit,
  ) async {
    if (event.showLoading) {
      emit(state.copyWith(isLoading: true));
    }

    await _tryFetchUserPosition();

    final result = await _getStationsDirectoryUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          errorMessage: '',
        ),
      ),
      (stations) {
        final enriched = stations.map((s) {
          if (_cachedPosition == null) return s;
          final dist = Geolocator.distanceBetween(
            _cachedPosition!.latitude,
            _cachedPosition!.longitude,
            s.latitude,
            s.longitude,
          );
          return s.copyWith(distanceInMeters: dist);
        }).toList();

        final cities = enriched.map((e) => e.city.trim()).where((c) => c.isNotEmpty).toSet().toList();

        _emitFilteredAndSortedState(
          emit: emit,
          allStations: enriched,
          availableCities: cities,
          selectedCity: state.selectedCity,
          sortOption: state.sortOption,
          statusFilter: state.statusFilter,
        );
      },
    );
  }

  void _onSelectCityFilter(
    SelectCityFilterEvent event,
    Emitter<StationsDirectoryState> emit,
  ) {
    _emitFilteredAndSortedState(
      emit: emit,
      allStations: state.allStations,
      availableCities: state.availableCities,
      selectedCity: event.city,
      sortOption: state.sortOption,
      statusFilter: state.statusFilter,
    );
  }

  void _onSelectSortOption(
    SelectSortOptionEvent event,
    Emitter<StationsDirectoryState> emit,
  ) {
    _emitFilteredAndSortedState(
      emit: emit,
      allStations: state.allStations,
      availableCities: state.availableCities,
      selectedCity: state.selectedCity,
      sortOption: event.sortOption,
      statusFilter: state.statusFilter,
    );
  }

  void _onSelectStatusFilter(
    SelectStatusFilterEvent event,
    Emitter<StationsDirectoryState> emit,
  ) {
    final nextFilter = state.statusFilter == event.statusFilter ? StationStatusFilter.all : event.statusFilter;

    _emitFilteredAndSortedState(
      emit: emit,
      allStations: state.allStations,
      availableCities: state.availableCities,
      selectedCity: state.selectedCity,
      sortOption: state.sortOption,
      statusFilter: nextFilter,
    );
  }

  void _emitFilteredAndSortedState({
    required Emitter<StationsDirectoryState> emit,
    required List<StationDirectoryEntity> allStations,
    required List<String> availableCities,
    required String? selectedCity,
    required StationSortOption sortOption,
    required StationStatusFilter statusFilter,
  }) {
    final cityStations = (selectedCity == null || selectedCity.isEmpty)
        ? allStations
        : allStations.where((s) => s.city == selectedCity).toList();

    final openCount = cityStations.where((s) => s.status == 'open').length;
    final refillingCount = cityStations.where((s) => s.status == 'refilling').length;
    final onTheWayCount = cityStations.where((s) => s.status == 'on_the_way').length;
    final closedCount = cityStations.where((s) => s.status == 'closed').length;

    List<StationDirectoryEntity> filtered = switch (statusFilter) {
      StationStatusFilter.all => List.of(cityStations),
      StationStatusFilter.open => cityStations.where((s) => s.status == 'open').toList(),
      StationStatusFilter.refilling => cityStations.where((s) => s.status == 'refilling').toList(),
      StationStatusFilter.onTheWay => cityStations.where((s) => s.status == 'on_the_way').toList(),
      StationStatusFilter.closed => cityStations.where((s) => s.status == 'closed').toList(),
    };

    filtered.sort((a, b) {
      switch (sortOption) {
        case StationSortOption.nearest:
          final distA = a.distanceInMeters ?? double.maxFinite;
          final distB = b.distanceInMeters ?? double.maxFinite;
          return distA.compareTo(distB);
        case StationSortOption.latestUpdated:
          return b.updatedAt.compareTo(a.updatedAt);
        case StationSortOption.leastCrowded:
          return a.crowdingScore.compareTo(b.crowdingScore);
      }
    });

    emit(
      state.copyWith(
        isLoading: false,
        allStations: allStations,
        displayedStations: filtered,
        availableCities: availableCities,
        selectedCity: selectedCity,
        clearSelectedCity: selectedCity == null,
        sortOption: sortOption,
        statusFilter: statusFilter,
        openCount: openCount,
        refillingCount: refillingCount,
        onTheWayCount: onTheWayCount,
        closedCount: closedCount,
      ),
    );
  }

  Future<void> _tryFetchUserPosition() async {
    if (_cachedPosition != null) return;
    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) return;
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        return;
      }
      _cachedPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 5),
        ),
      );
    } catch (_) {}
  }

  @override
  Future<void> close() {
    _realtimeSub?.cancel();
    return super.close();
  }
}
