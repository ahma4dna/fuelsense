import 'package:fuelsense/features/stations/data/models/field_report/field_report_model.dart';
import 'package:fuelsense/features/stations/data/models/station/station_model.dart';
import 'package:fuelsense/features/stations/data/models/station_history/station_history_model.dart';

import '../../domain/entities/field_report_entity.dart';
import '../../domain/entities/station_entity.dart';
import '../../domain/entities/station_history_entity.dart';
import '../../domain/extensions/station_extensions.dart';

extension StationModelMapper on StationModel {
  StationEntity toEntity() {
    final trafficLvl = TrafficLevelX.fromString(trafficStatus);
    return StationEntity(
      id: id ?? 0,
      name: name ?? 'محطة وقود',
      nameEn: nameEn,
      address: address ?? '',
      city: city ?? 'غير محدد',
      latitude: latitude ?? 0.0,
      longitude: longitude ?? 0.0,
      status: OfficialStationStatusX.fromString(status),
      statusSource: statusSource ?? 'official_facebook',
      statusSourceName: statusSourceName ?? 'لجنة توزيع الوقود الرسمية',
      lastFuelAmount: lastFuelAmount,
      statusNotes: statusNotes,
      aliases: aliases,
      trafficStatus: trafficLvl,
      trafficDelayRatio: trafficDelayRatio ?? 0,
      trafficDescription: trafficDescription ?? trafficLvl.arabicShortLabel,
      trafficUpdatedAt: trafficUpdatedAt,
      totalReports: totalReports ?? 0,
      fuelTypes: fuelTypes ?? const ['بنزين 91'],
      isActive: isActive ?? true,
      lastUpdated: lastUpdated ?? DateTime.now(),
      lastEvidenceAt: lastEvidenceAt,
    );
  }
}

extension FieldReportModelMapper on FieldReportModel {
  FieldReportEntity toEntity() {
    int? parsedConfidencePercent;
    if (aiConfidence != null) {
      // يدعم سواء كانت القيمة محفوظة 0.94 أو 94
      parsedConfidencePercent = aiConfidence! <= 1.0 ? (aiConfidence! * 100).round() : aiConfidence!.round();
    }

    final created = createdAt ?? DateTime.now();
    return FieldReportEntity(
      id: id ?? 0,
      nameUer: nameUser ?? "",
      userId: userId ?? '',
      stationId: stationId ?? 0,
      historyId: historyId,
      queueStatus: QueueLevelX.fromString(queueStatus),
      note: note,
      userLatitude: userLatitude ?? 0.0,
      userLongitude: userLongitude ?? 0.0,
      distanceToStationMeters: (distanceToStation ?? 0.0).round(),
      isWithinRange: isWithinRange ?? true,
      isCameraVerified: isCameraVerified ?? false,
      aiConfidencePercent: parsedConfidencePercent,
      aiInferenceMs: aiInferenceMs,
      confirmationsCount: confirmationsCount ?? 1,
      lastConfirmedAt: lastConfirmedAt ?? created,
      createdAt: created,
    );
  }
}

extension StationHistoryModelMapper on StationHistoryModel {
  StationHistoryEntity toEntity() {
    final trafficLvl = TrafficLevelX.fromString(trafficStatus);
    return StationHistoryEntity(
      id: id ?? 0,
      stationId: stationId ?? 0,
      status: OfficialStationStatusX.fromString(status),
      statusSource: statusSource ?? 'official_facebook',
      statusSourceName: statusSourceName ?? 'لجنة توزيع الوقود الرسمية',
      fuelAmount: fuelAmount,
      statusNotes: statusNotes,
      trafficStatus: trafficLvl,
      trafficDelayRatio: trafficDelayRatio ?? 0,
      trafficDescription: trafficDescription ?? trafficLvl.arabicShortLabel,
      postId: postId,
      reportsCount: reportsCount ?? 0,
      createdAt: createdAt ?? DateTime.now(),
    );
  }
}
