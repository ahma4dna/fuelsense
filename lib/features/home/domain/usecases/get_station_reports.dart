import 'package:fpdart/fpdart.dart';
import 'package:fuelsense/core/domain/models/failure.dart';
import 'package:fuelsense/features/home/data/models/report_model.dart';
import 'package:fuelsense/features/home/domain/repositories/station_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetStationReports {
  final StationRepository repository;

  GetStationReports(this.repository);

  Future<Either<Failure, List<ReportModel>>> call(
    int stationId, {
    int limit = 10,
  }) {
    return repository.getStationReports(
      stationId,
      limit: limit,
    );
  }
}
