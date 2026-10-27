import 'package:equatable/equatable.dart';

import '../../../../core/domain/models/failure.dart';
import '../../domain/entities/field_report_entity.dart';
import '../../domain/entities/station_entity.dart';
import '../../domain/enums/station_enums.dart';

sealed class StationsEvent extends Equatable {
  const StationsEvent();

  @override
  List<Object?> get props => [];
  @override
  bool get stringify => false;
}

final class WatchStationsEvent extends StationsEvent {}

final class UpdateStationsListEvent extends StationsEvent {
  final List<StationEntity> stations;
  const UpdateStationsListEvent({required this.stations});

  @override
  List<Object?> get props => [stations];
}

final class StationsStreamErrorEvent extends StationsEvent {
  final Failure error;
  const StationsStreamErrorEvent(this.error);

  @override
  List<Object?> get props => [error];
}

final class ChangeQuickFilterEvent extends StationsEvent {
  final StationQuickFilter filter;
  const ChangeQuickFilterEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}

final class ChangeCityFilterEvent extends StationsEvent {
  final String? city; // null
  const ChangeCityFilterEvent(this.city);

  @override
  List<Object?> get props => [city];
}

final class SearchStationsEvent extends StationsEvent {
  final String query;
  const SearchStationsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

final class SelectStationEvent extends StationsEvent {
  final StationEntity station;
  final double? userLatitude;
  final double? userLongitude;

  const SelectStationEvent({
    required this.station,
    this.userLatitude,
    this.userLongitude,
  });

  @override
  List<Object?> get props => [station, userLatitude, userLongitude];
}

final class UpdateTodayReportsEvent extends StationsEvent {
  final List<FieldReportEntity> reports;
  const UpdateTodayReportsEvent({required this.reports});

  @override
  List<Object?> get props => [reports];
}

final class TodayReportsStreamErrorEvent extends StationsEvent {
  final Failure error;
  const TodayReportsStreamErrorEvent(this.error);

  @override
  List<Object?> get props => [error];
}

final class LoadStationHistoryEvent extends StationsEvent {
  final int stationId;
  const LoadStationHistoryEvent(this.stationId);

  @override
  List<Object?> get props => [stationId];
}

final class ToggleHistorySessionExpansionEvent extends StationsEvent {
  final int historyId;
  const ToggleHistorySessionExpansionEvent(this.historyId);

  @override
  List<Object?> get props => [historyId];
}

final class CheckUserGeofenceEvent extends StationsEvent {
  final double userLatitude;
  final double userLongitude;

  const CheckUserGeofenceEvent({
    required this.userLatitude,
    required this.userLongitude,
  });

  @override
  List<Object?> get props => [userLatitude, userLongitude];
}

final class SubmitFieldReportEvent extends StationsEvent {
  final QueueLevel queueStatus;
  final String? note;
  final double userLatitude;
  final double userLongitude;
  final bool isCameraVerified;
  final double? aiConfidence;
  final int? aiInferenceMs;

  const SubmitFieldReportEvent({
    required this.queueStatus,
    this.note,
    required this.userLatitude,
    required this.userLongitude,
    required this.isCameraVerified,
    this.aiConfidence,
    this.aiInferenceMs,
  });

  @override
  List<Object?> get props => [
    queueStatus,
    note,
    userLatitude,
    userLongitude,
    isCameraVerified,
    aiConfidence,
    aiInferenceMs,
  ];
}

final class ConfirmFieldReportEvent extends StationsEvent {
  final int reportId;
  final double userLatitude;
  final double userLongitude;

  const ConfirmFieldReportEvent({
    required this.reportId,
    required this.userLatitude,
    required this.userLongitude,
  });

  @override
  List<Object?> get props => [reportId, userLatitude, userLongitude];
}

final class LoadFavoriteStationsEvent extends StationsEvent {}

final class ToggleFavoriteStationEvent extends StationsEvent {
  final int stationId;
  const ToggleFavoriteStationEvent(this.stationId);

  @override
  List<Object?> get props => [stationId];
}
