import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:fuelsense/core/domain/models/failure.dart';
import 'package:fuelsense/features/home/data/models/report_model.dart';
import 'package:fuelsense/features/home/data/models/review_model.dart';
import 'package:fuelsense/features/home/data/models/station_model.dart';

abstract class StationRepository {
  Future<Either<Failure, List<StationModel>>> getNearbyStations({
    required double latitude,
    required double longitude,
    double radiusKm = 20,
  });

  Stream<Either<Failure, List<StationModel>>> watchStations();

  Future<Either<Failure, List<StationModel>>> searchStations(String query);

  Future<Either<Failure, StationModel>> getStationById(int stationId);

  Future<Either<Failure, List<ReportModel>>> getStationReports(
    int stationId, {
    int limit = 10,
  });

  Future<Either<Failure, List<ReviewModel>>> getStationReviews(
    int stationId, {
    int limit = 10,
  });

  Future<Either<Failure, ReportModel>> submitReport({
    required int stationId,
    required String status,
    required double userLatitude,
    required double userLongitude,
    int? carCount,
    String? note,
    File? photo,
  });

  Future<Either<Failure, ReviewModel>> submitReview({
    required int stationId,
    required int rating,
    required String actualStatus,
    required bool predictionWasCorrect,
    String? comment,
    double? predictionAtVisit,
  });

  Future<Either<Failure, String>> uploadReportPhoto(File photo);

  /// جلب بلاغاتي (سجل بلاغات المستخدم الحالي)
  // Future<Either<Failure, List<ReportModel>>> getMyReports({int limit = 20});

  bool isWithinRange({
    required double userLat,
    required double userLng,
    required double stationLat,
    required double stationLng,
    double maxDistanceMeters = 200,
  });

  double calculateDistance({
    required double lat1,
    required double lng1,
    required double lat2,
    required double lng2,
  });
}
