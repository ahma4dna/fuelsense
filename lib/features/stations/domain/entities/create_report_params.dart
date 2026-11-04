import 'package:equatable/equatable.dart';

class CreateReportParams extends Equatable {
  final int stationId;
  final String queueStatus; // 'light', 'medium', 'heavy', 'stopped'
  final String? note;
  final double userLatitude;
  final double userLongitude;
  final double distanceToStation;
  final bool isWithinRange;

  const CreateReportParams({
    required this.stationId,
    required this.queueStatus,
    this.note,
    required this.userLatitude,
    required this.userLongitude,
    required this.distanceToStation,
    required this.isWithinRange,
  });

  @override
  List<Object?> get props => [
    stationId,
    queueStatus,
    note,
    userLatitude,
    userLongitude,
    distanceToStation,
    isWithinRange,
  ];
}
