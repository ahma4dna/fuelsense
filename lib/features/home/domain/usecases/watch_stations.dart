import 'package:fpdart/fpdart.dart';
import 'package:fuelsense/core/domain/models/failure.dart';
import 'package:fuelsense/features/home/data/models/station_model.dart';
import 'package:fuelsense/features/home/domain/repositories/station_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class WatchStations {
  final StationRepository repository;

  WatchStations(this.repository);

  Stream<Either<Failure, List<StationModel>>> call() {
    return repository.watchStations();
  }
}
