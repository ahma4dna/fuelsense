// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'station_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StationModel _$StationModelFromJson(Map<String, dynamic> json) => StationModel(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  nameEn: json['name_en'] as String?,
  address: json['address'] as String?,
  city: json['city'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  status: json['status'] as String?,
  statusSource: json['status_source'] as String?,
  statusSourceName: json['status_source_name'] as String?,
  lastFuelAmount: json['last_fuel_amount'] as String?,
  statusNotes: json['status_notes'] as String?,
  aliases: json['aliases'] as String?,
  trafficStatus: json['traffic_status'] as String?,
  trafficDelayRatio: (json['traffic_delay_ratio'] as num?)?.toInt(),
  trafficDescription: json['traffic_description'] as String?,
  trafficUpdatedAt: json['traffic_updated_at'] == null
      ? null
      : DateTime.parse(json['traffic_updated_at'] as String),
  totalReports: (json['total_reports'] as num?)?.toInt(),
  fuelTypes: (json['fuel_types'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  isActive: json['is_active'] as bool?,
  lastUpdated: json['last_updated'] == null
      ? null
      : DateTime.parse(json['last_updated'] as String),
  lastEvidenceAt: json['last_evidence_at'] == null
      ? null
      : DateTime.parse(json['last_evidence_at'] as String),
);

Map<String, dynamic> _$StationModelToJson(StationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'name_en': instance.nameEn,
      'address': instance.address,
      'city': instance.city,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'status': instance.status,
      'status_source': instance.statusSource,
      'status_source_name': instance.statusSourceName,
      'last_fuel_amount': instance.lastFuelAmount,
      'status_notes': instance.statusNotes,
      'aliases': instance.aliases,
      'traffic_status': instance.trafficStatus,
      'traffic_delay_ratio': instance.trafficDelayRatio,
      'traffic_description': instance.trafficDescription,
      'traffic_updated_at': instance.trafficUpdatedAt?.toIso8601String(),
      'total_reports': instance.totalReports,
      'fuel_types': instance.fuelTypes,
      'is_active': instance.isActive,
      'last_updated': instance.lastUpdated?.toIso8601String(),
      'last_evidence_at': instance.lastEvidenceAt?.toIso8601String(),
    };
