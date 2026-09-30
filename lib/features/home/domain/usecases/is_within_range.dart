import 'package:fuelsense/features/home/domain/repositories/station_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class IsWithinRange {
  final StationRepository repository;

  IsWithinRange(this.repository);

  bool call({
    required double userLat,
    required double userLng,
    required double stationLat,
    required double stationLng,
    double maxDistanceMeters = 200,
  }) {
    return repository.isWithinRange(
      userLat: userLat,
      userLng: userLng,
      stationLat: stationLat,
      stationLng: stationLng,
      maxDistanceMeters: maxDistanceMeters,
    );
  }
}
