import 'package:json_annotation/json_annotation.dart';

part 'station_history_model.g.dart';

@JsonSerializable()
class StationHistoryModel {
  final int? id;
  @JsonKey(name: 'station_id')
  final int? stationId;
  final String? status;
  @JsonKey(name: 'status_source')
  final String? statusSource;
  @JsonKey(name: 'status_source_name')
  final String? statusSourceName;
  @JsonKey(name: 'fuel_amount')
  final String? fuelAmount;
  @JsonKey(name: 'status_notes')
  final String? statusNotes;
  @JsonKey(name: 'traffic_status')
  final String? trafficStatus;
  @JsonKey(name: 'traffic_delay_ratio')
  final int? trafficDelayRatio;
  @JsonKey(name: 'traffic_description')
  final String? trafficDescription;
  @JsonKey(name: 'post_id')
  final String? postId;
  @JsonKey(name: 'reports_count')
  final int? reportsCount;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  const StationHistoryModel({
    this.id,
    this.stationId,
    this.status,
    this.statusSource,
    this.statusSourceName,
    this.fuelAmount,
    this.statusNotes,
    this.trafficStatus,
    this.trafficDelayRatio,
    this.trafficDescription,
    this.postId,
    this.reportsCount,
    this.createdAt,
  });

  factory StationHistoryModel.fromJson(Map<String, dynamic> json) => _$StationHistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$StationHistoryModelToJson(this);
}
