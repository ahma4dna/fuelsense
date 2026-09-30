import 'package:fpdart/fpdart.dart';
import 'package:fuelsense/core/domain/models/failure.dart';
import 'package:fuelsense/features/home/data/models/station_model.dart';
import 'package:fuelsense/features/home/domain/repositories/station_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetStationById {
  final StationRepository repository;

  GetStationById(this.repository);

  Future<Either<Failure, StationModel>> call(int stationId) {
    return repository.getStationById(stationId);
  }
}
