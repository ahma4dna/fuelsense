import 'package:equatable/equatable.dart';

import '../enums/station_enums.dart';
import '../extensions/station_extensions.dart';
import 'station_entity.dart';
import 'station_history_entity.dart';

class StationBehaviorInsightsEntity extends Equatable {
  final int refillsLast7DaysCount;
  final List<bool> last7DaysActivityDots;
  final String lastPreviousSupplyText;
  final String usualSupplyPeriodText;

  const StationBehaviorInsightsEntity({
    required this.refillsLast7DaysCount,
    required this.last7DaysActivityDots,
    required this.lastPreviousSupplyText,
    required this.usualSupplyPeriodText,
  });

  factory StationBehaviorInsightsEntity.fromHistoryList(List<StationHistoryEntity> history) {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));

    final supplyEvents = history
        .where((h) => h.status == OfficialStationStatus.refilling || h.status == OfficialStationStatus.open)
        .toList();

    final recentSupplies = supplyEvents.where((h) => h.createdAt.isAfter(sevenDaysAgo)).toList();

    final List<bool> dots = List.generate(7, (index) {
      final targetDay = now.subtract(Duration(days: 6 - index));
      return recentSupplies.any(
        (h) =>
            h.createdAt.year == targetDay.year &&
            h.createdAt.month == targetDay.month &&
            h.createdAt.day == targetDay.day,
      );
    });

    String lastSupplyText = 'لا توجد طلبية سابقة مسجلة';
    if (supplyEvents.isNotEmpty) {
      final targetEvent = supplyEvents.length > 1 ? supplyEvents[1] : supplyEvents.first;
      final relDate = StationGeoAndTimeUtils.formatRelativeArabic(targetEvent.createdAt, useQablForDays: true);
      final amount = (targetEvent.fuelAmount != null && targetEvent.fuelAmount!.isNotEmpty)
          ? ' (${targetEvent.fuelAmount})'
          : '';
      lastSupplyText = '$relDate$amount';
    }

    String usualPeriod = 'غير محدد بعد';
    if (supplyEvents.isNotEmpty) {
      int eveningCount = 0;
      for (final ev in supplyEvents) {
        if (ev.createdAt.hour >= 12) eveningCount++;
      }
      usualPeriod = (eveningCount >= (supplyEvents.length / 2)) ? 'غالباً الفترة المسائية' : 'غالباً الفترة الصباحية';
    }

    return StationBehaviorInsightsEntity(
      refillsLast7DaysCount: recentSupplies.length,
      last7DaysActivityDots: dots,
      lastPreviousSupplyText: lastSupplyText,
      usualSupplyPeriodText: usualPeriod,
    );
  }

  @override
  List<Object?> get props => [
    refillsLast7DaysCount,
    last7DaysActivityDots,
    lastPreviousSupplyText,
    usualSupplyPeriodText,
  ];
}

class StationsSummaryCountsEntity extends Equatable {
  final int openCount;
  final int refillingCount;
  final int onTheWayCount;
  final int closedOrEmptyCount;

  const StationsSummaryCountsEntity({
    this.openCount = 0,
    this.refillingCount = 0,
    this.onTheWayCount = 0,
    this.closedOrEmptyCount = 0,
  });

  factory StationsSummaryCountsEntity.fromStations(List<StationEntity> stations) {
    int open = 0;
    int refilling = 0;
    int onTheWay = 0;
    int closed = 0;

    for (final st in stations) {
      switch (st.status) {
        case OfficialStationStatus.open:
          open++;
          break;
        case OfficialStationStatus.refilling:
          refilling++;
          break;
        case OfficialStationStatus.onTheWay:
          onTheWay++;
          break;
        case OfficialStationStatus.closed:
        case OfficialStationStatus.outOfFuel:
        case OfficialStationStatus.unknown:
          closed++;
          break;
      }
    }

    return StationsSummaryCountsEntity(
      openCount: open,
      refillingCount: refilling,
      onTheWayCount: onTheWay,
      closedOrEmptyCount: closed,
    );
  }

  @override
  List<Object?> get props => [openCount, refillingCount, onTheWayCount, closedOrEmptyCount];
}
