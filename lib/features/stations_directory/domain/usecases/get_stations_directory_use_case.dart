import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/domain/models/failure.dart';
import '../entities/station_directory_entity.dart';
import '../repositories/stations_directory_repository.dart';

@lazySingleton
class GetStationsDirectoryUseCase {
  final StationsDirectoryRepository _repository;

  GetStationsDirectoryUseCase(this._repository);

  Future<Either<Failure, List<StationDirectoryEntity>>> call() {
    return _repository.getStationsDirectory();
  }

  Stream<void> watchChanges() {
    return _repository.watchStationsChanges();
  }
}
