import 'package:json_annotation/json_annotation.dart';

part 'field_report_model.g.dart';

@JsonSerializable()
class FieldReportModel {
  final int? id;
  @JsonKey(name: 'user_id')
  final String? userId;
  @JsonKey(name: 'station_id')
  final int? stationId;
  @JsonKey(name: 'history_id')
  final int? historyId;
  @JsonKey(name: 'queue_status')
  final String? queueStatus;
  final String? note;
  @JsonKey(name: 'user_latitude')
  final double? userLatitude;
  @JsonKey(name: 'user_longitude')
  final double? userLongitude;
  @JsonKey(name: 'distance_to_station')
  final double? distanceToStation;
  @JsonKey(name: 'is_within_range')
  final bool? isWithinRange;
  @JsonKey(name: 'is_camera_verified')
  final bool? isCameraVerified;
  @JsonKey(name: 'ai_confidence')
  final double? aiConfidence;
  @JsonKey(name: 'ai_inference_ms')
  final int? aiInferenceMs;
  @JsonKey(name: 'confirmations_count')
  final int? confirmationsCount;
  @JsonKey(name: 'last_confirmed_at')
  final DateTime? lastConfirmedAt;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  const FieldReportModel({
    this.id,
    this.userId,
    this.stationId,
    this.historyId,
    this.queueStatus,
    this.note,
    this.userLatitude,
    this.userLongitude,
    this.distanceToStation,
    this.isWithinRange,
    this.isCameraVerified,
    this.aiConfidence,
    this.aiInferenceMs,
    this.confirmationsCount,
    this.lastConfirmedAt,
    this.createdAt,
  });

  factory FieldReportModel.fromJson(Map<String, dynamic> json) => _$FieldReportModelFromJson(json);

  Map<String, dynamic> toJson() => _$FieldReportModelToJson(this);
}
