import 'package:fpdart/fpdart.dart';
import 'package:fuelsense/core/domain/models/failure.dart';
import 'package:fuelsense/features/home/data/models/review_model.dart';
import 'package:fuelsense/features/home/domain/repositories/station_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SubmitReview {
  final StationRepository repository;

  SubmitReview(this.repository);

  Future<Either<Failure, ReviewModel>> call({
    required int stationId,
    required int rating,
    required String actualStatus,
    required bool predictionWasCorrect,
    String? comment,
    double? predictionAtVisit,
  }) {
    return repository.submitReview(
      stationId: stationId,
      rating: rating,
      actualStatus: actualStatus,
      predictionWasCorrect: predictionWasCorrect,
      comment: comment,
      predictionAtVisit: predictionAtVisit,
    );
  }
}
