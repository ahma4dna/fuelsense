import 'package:fpdart/fpdart.dart';

import '../../../../core/domain/models/failure.dart';
import '../entities/station_directory_entity.dart';

abstract class StationsDirectoryRepository {
  Future<Either<Failure, List<StationDirectoryEntity>>> getStationsDirectory();
  Stream<void> watchStationsChanges();
}
