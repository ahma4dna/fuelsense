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
  currentProbability: (json['current_probability'] as num?)?.toDouble(),
  status: json['status'] as String?,
  statusSource: json['status_source'] as String?,
  lastUpdated: json['last_updated'] == null
      ? null
      : DateTime.parse(json['last_updated'] as String),
  totalReports: (json['total_reports'] as num?)?.toInt(),
  totalReviews: (json['total_reviews'] as num?)?.toInt(),
  avgPredictionRating: (json['avg_prediction_rating'] as num?)?.toDouble(),
  fuelTypes: (json['fuel_types'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  isActive: json['is_active'] as bool?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  distanceMeters: (json['distance_meters'] as num?)?.toDouble(),
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
      'current_probability': instance.currentProbability,
      'status': instance.status,
      'status_source': instance.statusSource,
      'last_updated': instance.lastUpdated?.toIso8601String(),
      'total_reports': instance.totalReports,
      'total_reviews': instance.totalReviews,
      'avg_prediction_rating': instance.avgPredictionRating,
      'fuel_types': instance.fuelTypes,
      'is_active': instance.isActive,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'distance_meters': instance.distanceMeters,
    };
