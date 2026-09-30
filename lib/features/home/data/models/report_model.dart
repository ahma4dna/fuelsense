import 'package:json_annotation/json_annotation.dart';

part 'report_model.g.dart';

@JsonSerializable()
class ReportModel {
  final int? id;

  @JsonKey(name: 'user_id')
  final String? userId;

  @JsonKey(name: 'station_id')
  final int? stationId;

  final String? status;

  @JsonKey(name: 'car_count')
  final int? carCount;

  @JsonKey(name: 'photo_url')
  final String? photoUrl;

  final String? note;

  @JsonKey(name: 'user_latitude')
  final double? userLatitude;

  @JsonKey(name: 'user_longitude')
  final double? userLongitude;

  @JsonKey(name: 'distance_to_station')
  final double? distanceToStation;

  @JsonKey(name: 'is_within_range')
  final bool? isWithinRange;

  @JsonKey(name: 'is_verified')
  final bool? isVerified;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @JsonKey(name: 'profiles')
  final ReporterProfile? reporter;

  /// يأتي عند جلب بلاغاتي (join مع stations)
  @JsonKey(name: 'stations')
  final ReportStation? station;

  const ReportModel({
    this.id,
    this.userId,
    this.stationId,
    this.status,
    this.carCount,
    this.photoUrl,
    this.note,
    this.userLatitude,
    this.userLongitude,
    this.distanceToStation,
    this.isWithinRange,
    this.isVerified,
    this.createdAt,
    this.reporter,
    this.station,
  });

  String get statusLabel => status == 'open' ? 'مفتوحة' : 'مغلقة';

  String get timeAgo {
    if (createdAt == null) return '';
    final diff = DateTime.now().difference(createdAt!);
    if (diff.inMinutes < 1) return 'الآن';
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
    return 'منذ ${diff.inDays} يوم';
  }

  factory ReportModel.fromJson(Map<String, dynamic> json) => _$ReportModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReportModelToJson(this);
}

@JsonSerializable()
class ReporterProfile {
  @JsonKey(name: 'full_name')
  final String? fullName;

  @JsonKey(name: 'trust_level')
  final String? trustLevel;

  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;

  const ReporterProfile({this.fullName, this.trustLevel, this.avatarUrl});

  String get trustLabel {
    switch (trustLevel) {
      case 'expert':
        return 'خبير';
      case 'trusted':
        return 'موثوق';
      case 'active':
        return 'فعّال';
      default:
        return 'مبتدئ';
    }
  }

  factory ReporterProfile.fromJson(Map<String, dynamic> json) => _$ReporterProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ReporterProfileToJson(this);
}

@JsonSerializable()
class ReportStation {
  final String? name;
  final String? address;

  const ReportStation({this.name, this.address});

  factory ReportStation.fromJson(Map<String, dynamic> json) => _$ReportStationFromJson(json);

  Map<String, dynamic> toJson() => _$ReportStationToJson(this);
}
