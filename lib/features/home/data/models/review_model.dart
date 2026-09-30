import 'package:json_annotation/json_annotation.dart';

import 'report_model.dart'; // لاستخدام ReporterProfile

part 'review_model.g.dart';

@JsonSerializable()
class ReviewModel {
  final int? id;

  @JsonKey(name: 'user_id')
  final String? userId;

  @JsonKey(name: 'station_id')
  final int? stationId;

  final int? rating;

  final String? comment;

  @JsonKey(name: 'actual_status')
  final String? actualStatus;

  @JsonKey(name: 'prediction_was_correct')
  final bool? predictionWasCorrect;

  @JsonKey(name: 'prediction_at_visit')
  final double? predictionAtVisit;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @JsonKey(name: 'profiles')
  final ReporterProfile? reviewer;

  const ReviewModel({
    this.id,
    this.userId,
    this.stationId,
    this.rating,
    this.comment,
    this.actualStatus,
    this.predictionWasCorrect,
    this.predictionAtVisit,
    this.createdAt,
    this.reviewer,
  });

  String get actualStatusLabel {
    switch (actualStatus) {
      case 'open':
        return 'مفتوحة';
      case 'closed':
        return 'مغلقة';
      case 'open_no_fuel':
        return 'مفتوحة بدون وقود';
      default:
        return 'غير معروف';
    }
  }

  String get timeAgo {
    if (createdAt == null) return '';
    final diff = DateTime.now().difference(createdAt!);
    if (diff.inMinutes < 1) return 'الآن';
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
    return 'منذ ${diff.inDays} يوم';
  }

  factory ReviewModel.fromJson(Map<String, dynamic> json) => _$ReviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);
}
