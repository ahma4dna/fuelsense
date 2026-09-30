import 'package:fpdart/fpdart.dart';
import 'package:fuelsense/core/domain/models/failure.dart';
import 'package:fuelsense/features/home/data/models/station_model.dart';
import 'package:fuelsense/features/home/domain/repositories/station_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetNearbyStations {
  final StationRepository repository;

  GetNearbyStations(this.repository);

  Future<Either<Failure, List<StationModel>>> call({
    required double latitude,
    required double longitude,
    double radiusKm = 20,
  }) {
    return repository.getNearbyStations(
      latitude: latitude,
      longitude: longitude,
      radiusKm: radiusKm,
    );
  }
}
