// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewModel _$ReviewModelFromJson(Map<String, dynamic> json) => ReviewModel(
  id: (json['id'] as num?)?.toInt(),
  userId: json['user_id'] as String?,
  stationId: (json['station_id'] as num?)?.toInt(),
  rating: (json['rating'] as num?)?.toInt(),
  comment: json['comment'] as String?,
  actualStatus: json['actual_status'] as String?,
  predictionWasCorrect: json['prediction_was_correct'] as bool?,
  predictionAtVisit: (json['prediction_at_visit'] as num?)?.toDouble(),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  reviewer: json['profiles'] == null
      ? null
      : ReporterProfile.fromJson(json['profiles'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ReviewModelToJson(ReviewModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'station_id': instance.stationId,
      'rating': instance.rating,
      'comment': instance.comment,
      'actual_status': instance.actualStatus,
      'prediction_was_correct': instance.predictionWasCorrect,
      'prediction_at_visit': instance.predictionAtVisit,
      'created_at': instance.createdAt?.toIso8601String(),
      'profiles': instance.reviewer,
    };
