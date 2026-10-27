// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FieldReportModel _$FieldReportModelFromJson(Map<String, dynamic> json) =>
    FieldReportModel(
      id: (json['id'] as num?)?.toInt(),
      userId: json['user_id'] as String?,
      stationId: (json['station_id'] as num?)?.toInt(),
      historyId: (json['history_id'] as num?)?.toInt(),
      queueStatus: json['queue_status'] as String?,
      note: json['note'] as String?,
      userLatitude: (json['user_latitude'] as num?)?.toDouble(),
      userLongitude: (json['user_longitude'] as num?)?.toDouble(),
      distanceToStation: (json['distance_to_station'] as num?)?.toDouble(),
      isWithinRange: json['is_within_range'] as bool?,
      isCameraVerified: json['is_camera_verified'] as bool?,
      aiConfidence: (json['ai_confidence'] as num?)?.toDouble(),
      aiInferenceMs: (json['ai_inference_ms'] as num?)?.toInt(),
      confirmationsCount: (json['confirmations_count'] as num?)?.toInt(),
      lastConfirmedAt: json['last_confirmed_at'] == null
          ? null
          : DateTime.parse(json['last_confirmed_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$FieldReportModelToJson(FieldReportModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'station_id': instance.stationId,
      'history_id': instance.historyId,
      'queue_status': instance.queueStatus,
      'note': instance.note,
      'user_latitude': instance.userLatitude,
      'user_longitude': instance.userLongitude,
      'distance_to_station': instance.distanceToStation,
      'is_within_range': instance.isWithinRange,
      'is_camera_verified': instance.isCameraVerified,
      'ai_confidence': instance.aiConfidence,
      'ai_inference_ms': instance.aiInferenceMs,
      'confirmations_count': instance.confirmationsCount,
      'last_confirmed_at': instance.lastConfirmedAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
    };
