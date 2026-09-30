// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportModel _$ReportModelFromJson(Map<String, dynamic> json) => ReportModel(
  id: (json['id'] as num?)?.toInt(),
  userId: json['user_id'] as String?,
  stationId: (json['station_id'] as num?)?.toInt(),
  status: json['status'] as String?,
  carCount: (json['car_count'] as num?)?.toInt(),
  photoUrl: json['photo_url'] as String?,
  note: json['note'] as String?,
  userLatitude: (json['user_latitude'] as num?)?.toDouble(),
  userLongitude: (json['user_longitude'] as num?)?.toDouble(),
  distanceToStation: (json['distance_to_station'] as num?)?.toDouble(),
  isWithinRange: json['is_within_range'] as bool?,
  isVerified: json['is_verified'] as bool?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  reporter: json['profiles'] == null
      ? null
      : ReporterProfile.fromJson(json['profiles'] as Map<String, dynamic>),
  station: json['stations'] == null
      ? null
      : ReportStation.fromJson(json['stations'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ReportModelToJson(ReportModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'station_id': instance.stationId,
      'status': instance.status,
      'car_count': instance.carCount,
      'photo_url': instance.photoUrl,
      'note': instance.note,
      'user_latitude': instance.userLatitude,
      'user_longitude': instance.userLongitude,
      'distance_to_station': instance.distanceToStation,
      'is_within_range': instance.isWithinRange,
      'is_verified': instance.isVerified,
      'created_at': instance.createdAt?.toIso8601String(),
      'profiles': instance.reporter,
      'stations': instance.station,
    };

ReporterProfile _$ReporterProfileFromJson(Map<String, dynamic> json) =>
    ReporterProfile(
      fullName: json['full_name'] as String?,
      trustLevel: json['trust_level'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );

Map<String, dynamic> _$ReporterProfileToJson(ReporterProfile instance) =>
    <String, dynamic>{
      'full_name': instance.fullName,
      'trust_level': instance.trustLevel,
      'avatar_url': instance.avatarUrl,
    };

ReportStation _$ReportStationFromJson(Map<String, dynamic> json) =>
    ReportStation(
      name: json['name'] as String?,
      address: json['address'] as String?,
    );

Map<String, dynamic> _$ReportStationToJson(ReportStation instance) =>
    <String, dynamic>{'name': instance.name, 'address': instance.address};
