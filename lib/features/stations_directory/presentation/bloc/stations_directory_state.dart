import 'package:equatable/equatable.dart';

import '../../domain/entities/station_directory_entity.dart';
import '../../domain/enums/station_directory_enums.dart';

class StationsDirectoryState extends Equatable {
  final bool isLoading;
  final List<StationDirectoryEntity> allStations;
  final List<StationDirectoryEntity> displayedStations;
  final List<String> availableCities;
  final String? selectedCity;
  final StationSortOption sortOption;
  final StationStatusFilter statusFilter;
  final int openCount;
  final int refillingCount;
  final int onTheWayCount;
  final int closedCount;
  final String? errorMessage;

  const StationsDirectoryState({
    this.isLoading = true,
    this.allStations = const [],
    this.displayedStations = const [],
    this.availableCities = const [],
    this.selectedCity,
    this.sortOption = StationSortOption.nearest,
    this.statusFilter = StationStatusFilter.all,
    this.openCount = 0,
    this.refillingCount = 0,
    this.onTheWayCount = 0,
    this.closedCount = 0,
    this.errorMessage,
  });

  String get cityHeaderLabel {
    if (selectedCity != null && selectedCity!.isNotEmpty) {
      return 'محطات مدينة $selectedCity';
    }
    final citiesCount = availableCities.isEmpty ? 5 : availableCities.length;
    return 'جميع مدن الساحل الغربي ($citiesCount مدن)';
  }

  StationsDirectoryState copyWith({
    bool? isLoading,
    List<StationDirectoryEntity>? allStations,
    List<StationDirectoryEntity>? displayedStations,
    List<String>? availableCities,
    String? selectedCity,
    bool clearSelectedCity = false,
    StationSortOption? sortOption,
    StationStatusFilter? statusFilter,
    int? openCount,
    int? refillingCount,
    int? onTheWayCount,
    int? closedCount,
    String? errorMessage,
  }) {
    return StationsDirectoryState(
      isLoading: isLoading ?? this.isLoading,
      allStations: allStations ?? this.allStations,
      displayedStations: displayedStations ?? this.displayedStations,
      availableCities: availableCities ?? this.availableCities,
      selectedCity: clearSelectedCity ? null : (selectedCity ?? this.selectedCity),
      sortOption: sortOption ?? this.sortOption,
      statusFilter: statusFilter ?? this.statusFilter,
      openCount: openCount ?? this.openCount,
      refillingCount: refillingCount ?? this.refillingCount,
      onTheWayCount: onTheWayCount ?? this.onTheWayCount,
      closedCount: closedCount ?? this.closedCount,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    allStations,
    displayedStations,
    availableCities,
    selectedCity,
    sortOption,
    statusFilter,
    openCount,
    refillingCount,
    onTheWayCount,
    closedCount,
    errorMessage,
  ];
}
