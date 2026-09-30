import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:fuelsense/core/domain/models/failure.dart';
import 'package:fuelsense/features/home/data/models/report_model.dart';
import 'package:fuelsense/features/home/domain/repositories/station_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SubmitReport {
  final StationRepository repository;

  SubmitReport(this.repository);

  Future<Either<Failure, ReportModel>> call({
    required int stationId,
    required String status,
    required double userLatitude,
    required double userLongitude,
    int? carCount,
    String? note,
    File? photo,
  }) {
    return repository.submitReport(
      stationId: stationId,
      status: status,
      userLatitude: userLatitude,
      userLongitude: userLongitude,
      carCount: carCount,
      note: note,
      photo: photo,
    );
  }
}
