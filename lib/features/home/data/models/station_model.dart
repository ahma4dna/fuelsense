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

  @JsonKey(name: 'current_probability')
  final double? currentProbability;

  final String? status;

  @JsonKey(name: 'status_source')
  final String? statusSource;

  @JsonKey(name: 'last_updated')
  final DateTime? lastUpdated;

  @JsonKey(name: 'total_reports')
  final int? totalReports;

  @JsonKey(name: 'total_reviews')
  final int? totalReviews;

  @JsonKey(name: 'avg_prediction_rating')
  final double? avgPredictionRating;

  @JsonKey(name: 'fuel_types')
  final List<String>? fuelTypes;

  @JsonKey(name: 'is_active')
  final bool? isActive;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  /// يأتي من دالة get_nearby_stations (ليس عمود في الجدول)
  @JsonKey(name: 'distance_meters')
  final double? distanceMeters;

  const StationModel({
    this.id,
    this.name,
    this.nameEn,
    this.address,
    this.city,
    this.latitude,
    this.longitude,
    this.currentProbability,
    this.status,
    this.statusSource,
    this.lastUpdated,
    this.totalReports,
    this.totalReviews,
    this.avgPredictionRating,
    this.fuelTypes,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.distanceMeters,
  });

  /// تحويل المسافة من أمتار إلى كيلومترات
  String get distanceFormatted {
    if (distanceMeters == null) return '';
    if (distanceMeters! < 1000) {
      return '${distanceMeters!.toInt()} م';
    }
    return '${(distanceMeters! / 1000).toStringAsFixed(1)} كم';
  }

  /// لون الحالة حسب الاحتمالية
  String get statusLabel {
    final p = currentProbability ?? 0;
    if (p >= 0.8) return 'مفتوحة';
    if (p >= 0.4) return 'غير مؤكدة';
    if (p > 0) return 'مغلقة';
    return 'غير معروفة';
  }

  factory StationModel.fromJson(Map<String, dynamic> json) => _$StationModelFromJson(json);

  Map<String, dynamic> toJson() => _$StationModelToJson(this);
}
