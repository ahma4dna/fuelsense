import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';

part 'station_model.g.dart';

@JsonSerializable()
class StationModel {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'name_en')
  final String? nameEn;

  @JsonKey(name: 'address')
  final String address;

  @JsonKey(name: 'city')
  final String city;

  @JsonKey(name: 'latitude')
  final double latitude;

  @JsonKey(name: 'longitude')
  final double longitude;

  @JsonKey(name: 'current_probability')
  final double currentProbability;

  @JsonKey(name: 'status')
  final String status;

  @JsonKey(name: 'status_source')
  final String statusSource;

  @JsonKey(name: 'last_updated')
  final DateTime lastUpdated;

  @JsonKey(name: 'total_reports')
  final int totalReports;

  @JsonKey(name: 'total_reviews')
  final int totalReviews;

  @JsonKey(name: 'avg_prediction_rating')
  final double? avgPredictionRating;

  @JsonKey(name: 'fuel_types')
  final List<String>? fuelTypes;

  @JsonKey(name: 'is_active')
  final bool isActive;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @JsonKey(name: 'google_place_id')
  final String? googlePlaceId;

  @JsonKey(name: 'distance_meters')
  final double? distanceMeters;

  const StationModel({
    required this.id,
    required this.name,
    this.nameEn,
    required this.address,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.currentProbability,
    required this.status,
    required this.statusSource,
    required this.lastUpdated,
    required this.totalReports,
    required this.totalReviews,
    this.avgPredictionRating,
    this.fuelTypes,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.googlePlaceId,
    this.distanceMeters,
  });

  String get distanceFormatted {
    final distance = distanceMeters;

    if (distance == null) {
      return '';
    }

    if (distance < 1000) {
      return '${distance.toInt()} م';
    }

    return '${(distance / 1000).toStringAsFixed(1)} كم';
  }

  bool get isOpen => status == 'open';

  bool get isClosed => status == 'closed';

  bool get isUnknown => status == 'unknown';
  Color get statusLabelColor {
    switch (status) {
      case 'open':
        return Color(0XFF12B981);

      case 'probably_active':
        return Color(0XFF84CC15);

      case 'uncertain':
        return Color(0XFFF59E0C);

      case 'probably_closed':
        return Color(0XFFF97315);

      case 'closed':
        return Color(0XFFEF4444);

      case 'unknown':
        return Color(0XFF94A3B8);
      default:
        return Color(0XFF94A3B8);
    }
  }

  String get confidance {
    final pro = currentProbability * 100;
    if (pro >= 85) {
      return "ثقة عالية";
    } else if (pro >= 65) {
      return "ثقة متوسطة";
    } else {
      return "ثقة منخغظة";
    }
  }

  String get statusLabel {
    switch (status) {
      case 'open':
        return 'مفتوحة';

      case 'probably_active':
        return 'غالبًا نشطة';

      case 'uncertain':
        return 'غير مؤكدة';

      case 'probably_closed':
        return 'غالبًا مغلقة';

      case 'closed':
        return 'مغلقة';

      case 'unknown':
      default:
        return 'غير معروفة';
    }
  }

  factory StationModel.fromJson(Map<String, dynamic> json) => _$StationModelFromJson(json);

  Map<String, dynamic> toJson() => _$StationModelToJson(this);
}
