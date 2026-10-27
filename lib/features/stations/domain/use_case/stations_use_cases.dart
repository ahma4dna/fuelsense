import 'package:fpdart/fpdart.dart';
import 'package:fuelsense/features/stations/domain/repositories/stations_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/domain/models/failure.dart';
import '../entities/field_report_entity.dart';
import '../entities/station_entity.dart';
import '../entities/station_history_entity.dart';

@lazySingleton
class WatchStationsUseCase {
  final StationsRepository _repository;
  WatchStationsUseCase(this._repository);

  Stream<Either<Failure, List<StationEntity>>> call() => _repository.watchStations();
}

@lazySingleton
class WatchTodayReportsUseCase {
  final StationsRepository _repository;
  WatchTodayReportsUseCase(this._repository);

  Stream<Either<Failure, List<FieldReportEntity>>> call(int stationId) =>
      _repository.watchTodayStationReports(stationId);
}

@lazySingleton
class GetStationHistoryUseCase {
  final StationsRepository _repository;
  GetStationHistoryUseCase(this._repository);

  Future<Either<Failure, List<StationHistoryEntity>>> call(int stationId) => _repository.getStationHistory(stationId);
}

@lazySingleton
class GetHistoryReportsUseCase {
  final StationsRepository _repository;
  GetHistoryReportsUseCase(this._repository);

  Future<Either<Failure, List<FieldReportEntity>>> call(int historyId) => _repository.getReportsByHistoryId(historyId);
}

@lazySingleton
class SubmitFieldReportUseCase {
  final StationsRepository _repository;
  SubmitFieldReportUseCase(this._repository);

  Future<Either<Failure, void>> call(SubmitFieldReportParams params) => _repository.submitFieldReport(params);
}

@lazySingleton
class ConfirmFieldReportUseCase {
  final StationsRepository _repository;
  ConfirmFieldReportUseCase(this._repository);

  Future<Either<Failure, void>> call(ConfirmFieldReportParams params) => _repository.confirmFieldReport(params);
}

@lazySingleton
class GetUserConfirmedReportIdsUseCase {
  final StationsRepository _repository;
  GetUserConfirmedReportIdsUseCase(this._repository);

  Future<Either<Failure, List<int>>> call(int stationId) => _repository.getUserConfirmedReportIds(stationId);
}

@lazySingleton
class GetFavoriteStationIdsUseCase {
  final StationsRepository _repository;
  GetFavoriteStationIdsUseCase(this._repository);

  Future<Either<Failure, List<int>>> call() => _repository.getFavoriteStationIds();
}

@lazySingleton
class ToggleFavoriteStationUseCase {
  final StationsRepository _repository;
  ToggleFavoriteStationUseCase(this._repository);

  Future<Either<Failure, bool>> call(int stationId) => _repository.toggleFavoriteStation(stationId);
}
