// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'station_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StationHistoryModel _$StationHistoryModelFromJson(Map<String, dynamic> json) =>
    StationHistoryModel(
      id: (json['id'] as num?)?.toInt(),
      stationId: (json['station_id'] as num?)?.toInt(),
      status: json['status'] as String?,
      statusSource: json['status_source'] as String?,
      statusSourceName: json['status_source_name'] as String?,
      fuelAmount: json['fuel_amount'] as String?,
      statusNotes: json['status_notes'] as String?,
      trafficStatus: json['traffic_status'] as String?,
      trafficDelayRatio: (json['traffic_delay_ratio'] as num?)?.toInt(),
      trafficDescription: json['traffic_description'] as String?,
      postId: json['post_id'] as String?,
      reportsCount: (json['reports_count'] as num?)?.toInt(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$StationHistoryModelToJson(
  StationHistoryModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'station_id': instance.stationId,
  'status': instance.status,
  'status_source': instance.statusSource,
  'status_source_name': instance.statusSourceName,
  'fuel_amount': instance.fuelAmount,
  'status_notes': instance.statusNotes,
  'traffic_status': instance.trafficStatus,
  'traffic_delay_ratio': instance.trafficDelayRatio,
  'traffic_description': instance.trafficDescription,
  'post_id': instance.postId,
  'reports_count': instance.reportsCount,
  'created_at': instance.createdAt?.toIso8601String(),
};
