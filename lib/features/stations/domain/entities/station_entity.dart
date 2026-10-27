import 'package:equatable/equatable.dart';

import '../enums/station_enums.dart';
import '../extensions/station_extensions.dart';

class StationEntity extends Equatable {
  final int id;
  final String name;
  final String? nameEn;
  final String address;
  final String city;
  final double latitude;
  final double longitude;
  final OfficialStationStatus status;
  final String statusSource;
  final String statusSourceName;
  final String? lastFuelAmount;
  final String? statusNotes;
  final String? aliases;
  final TrafficLevel trafficStatus;
  final int trafficDelayRatio;
  final String trafficDescription;
  final DateTime? trafficUpdatedAt;
  final int totalReports;
  final List<String> fuelTypes;
  final bool isActive;
  final DateTime lastUpdated;
  final DateTime? lastEvidenceAt;

  const StationEntity({
    required this.id,
    required this.name,
    this.nameEn,
    required this.address,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.statusSource,
    required this.statusSourceName,
    this.lastFuelAmount,
    this.statusNotes,
    this.aliases,
    required this.trafficStatus,
    required this.trafficDelayRatio,
    required this.trafficDescription,
    this.trafficUpdatedAt,
    required this.totalReports,
    required this.fuelTypes,
    required this.isActive,
    required this.lastUpdated,
    this.lastEvidenceAt,
  });

  bool get isUpdatedToday {
    final now = DateTime.now();
    return lastUpdated.year == now.year && lastUpdated.month == now.month && lastUpdated.day == now.day;
  }

  String get lastUpdatedRelativeText => StationGeoAndTimeUtils.formatRelativeArabic(lastUpdated);

  double distanceFromUser({required double userLat, required double userLng}) {
    return StationGeoAndTimeUtils.calculateDistanceMeters(
      userLat: userLat,
      userLng: userLng,
      stationLat: latitude,
      stationLng: longitude,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    nameEn,
    address,
    city,
    latitude,
    longitude,
    status,
    statusSource,
    statusSourceName,
    lastFuelAmount,
    statusNotes,
    aliases,
    trafficStatus,
    trafficDelayRatio,
    trafficDescription,
    trafficUpdatedAt,
    totalReports,
    fuelTypes,
    isActive,
    lastUpdated,
    lastEvidenceAt,
  ];
}
