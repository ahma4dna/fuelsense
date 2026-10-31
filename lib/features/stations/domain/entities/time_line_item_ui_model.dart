import 'package:fuelsense/features/stations/domain/entities/station_history_entity.dart';
import 'package:fuelsense/features/stations/domain/enums/station_enums.dart';
import 'package:fuelsense/features/stations/domain/extensions/station_extensions.dart';

class TimelineItemUiModel {
  final int id;
  final String relativeTimeText;
  final OfficialStationStatus status;
  final String expandedStatusTitle;
  final String collapsedStatusText;
  final TrafficLevel trafficLevel;
  final int delayPercentage;
  final String expandedTrafficText;
  final String collapsedTrafficText;
  final int reportsCount;
  final String archiveSummaryText;

  const TimelineItemUiModel({
    required this.id,
    required this.relativeTimeText,
    required this.status,
    required this.expandedStatusTitle,
    required this.collapsedStatusText,
    required this.trafficLevel,
    required this.delayPercentage,
    required this.expandedTrafficText,
    required this.collapsedTrafficText,
    required this.reportsCount,
    required this.archiveSummaryText,
  });

  factory TimelineItemUiModel.fromEntity(StationHistoryEntity entity) {
    final amountText = (entity.fuelAmount != null && entity.fuelAmount!.trim().isNotEmpty)
        ? ' (${entity.fuelAmount})'
        : '';

    final String shortStatus;
    switch (entity.status) {
      case OfficialStationStatus.outOfFuel:
        shortStatus = 'مغلقة لنفاد الكمية';
        break;
      case OfficialStationStatus.closed:
        shortStatus = 'مغلقة';
        break;
      case OfficialStationStatus.refilling:
        shortStatus = 'تم تفريغ الطلبية$amountText';
        break;
      case OfficialStationStatus.onTheWay:
        shortStatus = 'الطلبية في الطريق$amountText';
        break;
      case OfficialStationStatus.open:
        shortStatus = 'مفتوحة للتوزيع$amountText';
        break;
      case OfficialStationStatus.unknown:
        shortStatus = 'غير محدد';
        break;
    }

    final String fullStatus = (entity.statusNotes != null && entity.statusNotes!.trim().isNotEmpty)
        ? entity.statusNotes!
        : shortStatus;

    final String fullTraffic = entity.trafficDelayRatio > 0
        ? 'حالة الطريق: ${entity.trafficDescription} (+${entity.trafficDelayRatio}% تأخير)'
        : 'حالة الطريق: ${entity.trafficDescription}';

    final String archiveText = entity.reportsCount > 0
        ? '${entity.reportsCount} بلاغات ميدانية مسجلة من المتواجدين خلال ذلك اليوم'
        : 'لا توجد بلاغات ميدانية مسجلة في ذلك اليوم';

    return TimelineItemUiModel(
      id: entity.id,
      relativeTimeText: entity.relativeDateLabel,
      status: entity.status,
      expandedStatusTitle: fullStatus,
      collapsedStatusText: shortStatus,
      trafficLevel: entity.trafficStatus,
      delayPercentage: entity.trafficDelayRatio,
      expandedTrafficText: fullTraffic,
      collapsedTrafficText: entity.trafficStatus.arabicShortLabel,
      reportsCount: entity.reportsCount,
      archiveSummaryText: archiveText,
    );
  }
}
