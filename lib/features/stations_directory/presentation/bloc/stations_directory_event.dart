import 'package:equatable/equatable.dart';

import '../../domain/enums/station_directory_enums.dart';

sealed class StationsDirectoryEvent extends Equatable {
  const StationsDirectoryEvent();

  @override
  List<Object?> get props => [];
}

final class LoadStationsDirectoryEvent extends StationsDirectoryEvent {
  final bool showLoading;
  const LoadStationsDirectoryEvent({this.showLoading = true});

  @override
  List<Object?> get props => [showLoading];
}

final class SelectCityFilterEvent extends StationsDirectoryEvent {
  final String? city;
  const SelectCityFilterEvent(this.city);

  @override
  List<Object?> get props => [city];
}

final class SelectSortOptionEvent extends StationsDirectoryEvent {
  final StationSortOption sortOption;
  const SelectSortOptionEvent(this.sortOption);

  @override
  List<Object?> get props => [sortOption];
}

final class SelectStatusFilterEvent extends StationsDirectoryEvent {
  final StationStatusFilter statusFilter;
  const SelectStatusFilterEvent(this.statusFilter);

  @override
  List<Object?> get props => [statusFilter];
}
