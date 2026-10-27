import 'package:json_annotation/json_annotation.dart';

part 'station_model.g.dart';

@JsonSerializable()
class StationModel {
  final int? id;
  final String? name;
  @JsonKey(name: 'name_en')
  final String? nameEn;
  final String? address;
  final String? city;
  final double? latitude;
  final double? longitude;
  final String? status;
  @JsonKey(name: 'status_source')
  final String? statusSource;
  @JsonKey(name: 'status_source_name')
  final String? statusSourceName;
  @JsonKey(name: 'last_fuel_amount')
  final String? lastFuelAmount;
  @JsonKey(name: 'status_notes')
  final String? statusNotes;
  final String? aliases;
  @JsonKey(name: 'traffic_status')
  final String? trafficStatus;
  @JsonKey(name: 'traffic_delay_ratio')
  final int? trafficDelayRatio;
  @JsonKey(name: 'traffic_description')
  final String? trafficDescription;
  @JsonKey(name: 'traffic_updated_at')
  final DateTime? trafficUpdatedAt;
  @JsonKey(name: 'total_reports')
  final int? totalReports;
  @JsonKey(name: 'fuel_types')
  final List<String>? fuelTypes;
  @JsonKey(name: 'is_active')
  final bool? isActive;
  @JsonKey(name: 'last_updated')
  final DateTime? lastUpdated;
  @JsonKey(name: 'last_evidence_at')
  final DateTime? lastEvidenceAt;

  const StationModel({
    this.id,
    this.name,
    this.nameEn,
    this.address,
    this.city,
    this.latitude,
    this.longitude,
    this.status,
    this.statusSource,
    this.statusSourceName,
    this.lastFuelAmount,
    this.statusNotes,
    this.aliases,
    this.trafficStatus,
    this.trafficDelayRatio,
    this.trafficDescription,
    this.trafficUpdatedAt,
    this.totalReports,
    this.fuelTypes,
    this.isActive,
    this.lastUpdated,
    this.lastEvidenceAt,
  });

  factory StationModel.fromJson(Map<String, dynamic> json) => _$StationModelFromJson(json);

  Map<String, dynamic> toJson() => _$StationModelToJson(this);
}
