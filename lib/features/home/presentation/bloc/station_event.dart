import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class StationEvent extends Equatable {
  const StationEvent();

  @override
  List<Object?> get props => [];
}

// ─────────────────────────────────────────────
// Stations
// ─────────────────────────────────────────────

class GetNearbyStationsEvent extends StationEvent {
  final double latitude;
  final double longitude;
  final double radiusKm;

  const GetNearbyStationsEvent({
    required this.latitude,
    required this.longitude,
    this.radiusKm = 20,
  });

  @override
  List<Object?> get props => [
    latitude,
    longitude,
    radiusKm,
  ];
}

class WatchStationsEvent extends StationEvent {
  const WatchStationsEvent();
}

class SearchStationsEvent extends StationEvent {
  final String query;

  const SearchStationsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class GetStationByIdEvent extends StationEvent {
  final int stationId;

  const GetStationByIdEvent(this.stationId);

  @override
  List<Object?> get props => [stationId];
}

// ─────────────────────────────────────────────
// Reports
// ─────────────────────────────────────────────

class GetStationReportsEvent extends StationEvent {
  final int stationId;
  final int limit;

  const GetStationReportsEvent({
    required this.stationId,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [
    stationId,
    limit,
  ];
}

class SubmitReportEvent extends StationEvent {
  final int stationId;
  final String status;
  final double userLatitude;
  final double userLongitude;
  final int? carCount;
  final String? note;
  final File? photo;

  const SubmitReportEvent({
    required this.stationId,
    required this.status,
    required this.userLatitude,
    required this.userLongitude,
    this.carCount,
    this.note,
    this.photo,
  });

  @override
  List<Object?> get props => [
    stationId,
    status,
    userLatitude,
    userLongitude,
    carCount,
    note,
    photo?.path,
  ];
}

class GetMyReportsEvent extends StationEvent {
  final int limit;

  const GetMyReportsEvent({
    this.limit = 20,
  });

  @override
  List<Object?> get props => [limit];
}

// ─────────────────────────────────────────────
// Reviews
// ─────────────────────────────────────────────

class GetStationReviewsEvent extends StationEvent {
  final int stationId;
  final int limit;

  const GetStationReviewsEvent({
    required this.stationId,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [
    stationId,
    limit,
  ];
}

class SubmitReviewEvent extends StationEvent {
  final int stationId;
  final int rating;
  final String actualStatus;
  final bool predictionWasCorrect;
  final String? comment;
  final double? predictionAtVisit;

  const SubmitReviewEvent({
    required this.stationId,
    required this.rating,
    required this.actualStatus,
    required this.predictionWasCorrect,
    this.comment,
    this.predictionAtVisit,
  });

  @override
  List<Object?> get props => [
    stationId,
    rating,
    actualStatus,
    predictionWasCorrect,
    comment,
    predictionAtVisit,
  ];
}
