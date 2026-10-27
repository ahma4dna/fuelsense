import 'package:equatable/equatable.dart';

import '../enums/station_enums.dart';
import '../extensions/station_extensions.dart';

class StationHistoryEntity extends Equatable {
  final int id;
  final int stationId;
  final OfficialStationStatus status;
  final String statusSource;
  final String statusSourceName;
  final String? fuelAmount;
  final String? statusNotes;
  final TrafficLevel trafficStatus;
  final int trafficDelayRatio;
  final String trafficDescription;
  final String? postId;
  final int reportsCount;
  final DateTime createdAt;

  const StationHistoryEntity({
    required this.id,
    required this.stationId,
    required this.status,
    required this.statusSource,
    required this.statusSourceName,
    this.fuelAmount,
    this.statusNotes,
    required this.trafficStatus,
    required this.trafficDelayRatio,
    required this.trafficDescription,
    this.postId,
    required this.reportsCount,
    required this.createdAt,
  });

  String get relativeDateLabel => StationGeoAndTimeUtils.formatRelativeArabic(createdAt, useQablForDays: true);

  @override
  List<Object?> get props => [
    id,
    stationId,
    status,
    statusSource,
    statusSourceName,
    fuelAmount,
    statusNotes,
    trafficStatus,
    trafficDelayRatio,
    trafficDescription,
    postId,
    reportsCount,
    createdAt,
  ];
}
