import 'package:fpdart/fpdart.dart';

import '../../../../core/domain/models/failure.dart';
import '../entities/field_report_entity.dart';
import '../entities/station_entity.dart';
import '../entities/station_history_entity.dart';
import '../enums/station_enums.dart';

class SubmitFieldReportParams {
  final int stationId;
  final String stationName;
  final String stationCity;
  final QueueLevel queueStatus;
  final String? note;
  final double userLatitude;
  final double userLongitude;
  final double distanceToStation;
  final bool isCameraVerified;
  final double? aiConfidence;
  final int? aiInferenceMs;

  const SubmitFieldReportParams({
    required this.stationId,
    required this.stationName,
    required this.stationCity,
    required this.queueStatus,
    this.note,
    required this.userLatitude,
    required this.userLongitude,
    required this.distanceToStation,
    required this.isCameraVerified,
    this.aiConfidence,
    this.aiInferenceMs,
  });
}

class ConfirmFieldReportParams {
  final int reportId;
  final double userLatitude;
  final double userLongitude;
  final double distanceToStation;

  const ConfirmFieldReportParams({
    required this.reportId,
    required this.userLatitude,
    required this.userLongitude,
    required this.distanceToStation,
  });
}

abstract class StationsRepository {
  Stream<Either<Failure, List<StationEntity>>> watchStations();

  Stream<Either<Failure, List<FieldReportEntity>>> watchTodayStationReports(int stationId);

  Future<Either<Failure, List<StationHistoryEntity>>> getStationHistory(int stationId);

  Future<Either<Failure, List<FieldReportEntity>>> getReportsByHistoryId(int historyId);

  Future<Either<Failure, void>> submitFieldReport(SubmitFieldReportParams params);

  Future<Either<Failure, void>> confirmFieldReport(ConfirmFieldReportParams params);

  Future<Either<Failure, List<int>>> getUserConfirmedReportIds(int stationId);

  Future<Either<Failure, List<int>>> getFavoriteStationIds();

  Future<Either<Failure, bool>> toggleFavoriteStation(int stationId);
}
