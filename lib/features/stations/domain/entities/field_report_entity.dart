import 'package:equatable/equatable.dart';

import '../enums/station_enums.dart';
import '../extensions/station_extensions.dart';

class FieldReportEntity extends Equatable {
  final int id;
  final String nameUer;
  final String userId;
  final int stationId;
  final int? historyId;
  final QueueLevel queueStatus;
  final String? note;
  final double userLatitude;
  final double userLongitude;
  final int distanceToStationMeters;
  final bool isWithinRange;
  final bool isCameraVerified;
  final int? aiConfidencePercent;
  final int? aiInferenceMs;
  final int confirmationsCount;
  final DateTime lastConfirmedAt;
  final DateTime createdAt;

  const FieldReportEntity({
    required this.id,
    required this.userId,
    required this.stationId,
    this.historyId,
    required this.queueStatus,
    this.note,
    required this.userLatitude,
    required this.userLongitude,
    required this.distanceToStationMeters,
    required this.isWithinRange,
    required this.isCameraVerified,
    this.aiConfidencePercent,
    this.aiInferenceMs,
    required this.confirmationsCount,
    required this.lastConfirmedAt,
    required this.createdAt,
    required this.nameUer,
  });

  String get verificationBadgeText {
    if (isCameraVerified) {
      final conf = aiConfidencePercent ?? 94;
      return 'موثق بالكاميرا والموقع الجغرافي (تطابق مضخة الوقود $conf%)';
    }
    return 'موثق بالموقع الجغرافي فقط (على بعد $distanceToStationMeters متر)';
  }

  String get confirmationButtonText {
    if (confirmationsCount <= 1) {
      return 'أؤكد هذا الوضع الآن';
    }
    final lastTime = StationGeoAndTimeUtils.formatRelativeArabic(lastConfirmedAt);
    return 'أؤكد هذا الوضع الآن (أكدها $confirmationsCount متواجدين - آخرهم $lastTime)';
  }

  String get createdAtRelativeText => StationGeoAndTimeUtils.formatRelativeArabic(createdAt);

  FieldReportEntity copyWith({
    int? confirmationsCount,
    DateTime? lastConfirmedAt,
  }) {
    return FieldReportEntity(
      id: id,
      nameUer: nameUer,
      userId: userId,
      stationId: stationId,
      historyId: historyId,
      queueStatus: queueStatus,
      note: note,
      userLatitude: userLatitude,
      userLongitude: userLongitude,
      distanceToStationMeters: distanceToStationMeters,
      isWithinRange: isWithinRange,
      isCameraVerified: isCameraVerified,
      aiConfidencePercent: aiConfidencePercent,
      aiInferenceMs: aiInferenceMs,
      confirmationsCount: confirmationsCount ?? this.confirmationsCount,
      lastConfirmedAt: lastConfirmedAt ?? this.lastConfirmedAt,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    stationId,
    historyId,
    queueStatus,
    note,
    userLatitude,
    userLongitude,
    distanceToStationMeters,
    isWithinRange,
    isCameraVerified,
    aiConfidencePercent,
    aiInferenceMs,
    confirmationsCount,
    lastConfirmedAt,
    createdAt,
  ];
}
