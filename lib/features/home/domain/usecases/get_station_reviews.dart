import 'package:fpdart/fpdart.dart';
import 'package:fuelsense/core/domain/models/failure.dart';
import 'package:fuelsense/features/home/data/models/review_model.dart';
import 'package:fuelsense/features/home/domain/repositories/station_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetStationReviews {
  final StationRepository repository;

  GetStationReviews(this.repository);

  Future<Either<Failure, List<ReviewModel>>> call(
    int stationId, {
    int limit = 10,
  }) {
    return repository.getStationReviews(
      stationId,
      limit: limit,
    );
  }
}
