import 'dart:math' as math;
import 'dart:ui';

import '../enums/station_enums.dart';

extension OfficialStationStatusX on OfficialStationStatus {
  String get dbValue {
    switch (this) {
      case OfficialStationStatus.open:
        return 'open';
      case OfficialStationStatus.refilling:
        return 'refilling';
      case OfficialStationStatus.onTheWay:
        return 'on_the_way';
      case OfficialStationStatus.closed:
        return 'closed';
      case OfficialStationStatus.outOfFuel:
        return 'out_of_fuel';
      case OfficialStationStatus.unknown:
        return 'unknown';
    }
  }

  String get arabicLabel {
    switch (this) {
      case OfficialStationStatus.open:
        return 'مفتوحة وتعمل';
      case OfficialStationStatus.refilling:
        return 'تم تفريغ الطلبية';
      case OfficialStationStatus.onTheWay:
        return 'الطلبية في الطريق';
      case OfficialStationStatus.closed:
        return 'مغلقة';
      case OfficialStationStatus.outOfFuel:
        return 'نفد الوقود';
      case OfficialStationStatus.unknown:
        return 'غير محدد';
    }
  }

  static OfficialStationStatus fromString(String? value) {
    switch (value) {
      case 'open':
        return OfficialStationStatus.open;
      case 'refilling':
        return OfficialStationStatus.refilling;
      case 'on_the_way':
        return OfficialStationStatus.onTheWay;
      case 'closed':
        return OfficialStationStatus.closed;
      case 'out_of_fuel':
        return OfficialStationStatus.outOfFuel;
      default:
        return OfficialStationStatus.unknown;
    }
  }
}

extension TrafficLevelX on TrafficLevel {
  String get dbValue {
    switch (this) {
      case TrafficLevel.normal:
        return 'normal';
      case TrafficLevel.busy:
        return 'busy';
      case TrafficLevel.heavy:
        return 'heavy';
    }
  }

  String get arabicShortLabel {
    switch (this) {
      case TrafficLevel.normal:
        return 'سير طبيعي';
      case TrafficLevel.busy:
        return 'مزدحم أكثر من العادة';
      case TrafficLevel.heavy:
        return 'ازدحام شديد أمام المحطة';
    }
  }

  static TrafficLevel fromString(String? value) {
    switch (value) {
      case 'busy':
        return TrafficLevel.busy;
      case 'heavy':
        return TrafficLevel.heavy;
      default:
        return TrafficLevel.normal;
    }
  }
}

extension QueueLevelX on QueueLevel {
  String get dbValue {
    switch (this) {
      case QueueLevel.light:
        return 'light';
      case QueueLevel.medium:
        return 'medium';
      case QueueLevel.heavy:
        return 'heavy';
      case QueueLevel.stopped:
        return 'stopped';
    }
  }

  String get arabicLabel {
    switch (this) {
      case QueueLevel.light:
        return 'خفيف وسريع';
      case QueueLevel.medium:
        return 'طابور متوسط';
      case QueueLevel.heavy:
        return 'مزدحم جداً';
      case QueueLevel.stopped:
        return 'متوقف حالياً';
    }
  }

  static QueueLevel fromString(String? value) {
    switch (value) {
      case 'light':
        return QueueLevel.light;
      case 'heavy':
        return QueueLevel.heavy;
      case 'stopped':
        return QueueLevel.stopped;
      default:
        return QueueLevel.medium;
    }
  }
}

extension StationQuickFilterX on StationQuickFilter {
  String get arabicLabel {
    switch (this) {
      case StationQuickFilter.all:
        return 'الكل';
      case StationQuickFilter.openNow:
        return 'مفتوحة الآن';
      case StationQuickFilter.refilledToday:
        return 'تم التفريغ اليوم';
      case StationQuickFilter.onTheWay:
        return 'في الطريق';
      case StationQuickFilter.normalTraffic:
        return 'طريق غير مزدحم';
    }
  }

  Color get getFilterColors {
    switch (this) {
      case StationQuickFilter.openNow:
        return Color(0xFF12B76A);
      case StationQuickFilter.refilledToday:
        return Color(0xFFF79009);
      case StationQuickFilter.onTheWay:
        return Color(0xFF2E90FA);
      case StationQuickFilter.normalTraffic:
        return Color(0xFF667085);
      default:
        return Color(0XFF111111);
    }
  }
}

class StationGeoAndTimeUtils {
  static const double maxAllowedDistanceMeters = 200.0;

  static double calculateDistanceMeters({
    required double userLat,
    required double userLng,
    required double stationLat,
    required double stationLng,
  }) {
    const double earthRadiusMeters = 6371000.0;
    final double dLat = _degToRad(stationLat - userLat);
    final double dLng = _degToRad(stationLng - userLng);

    final double a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degToRad(userLat)) * math.cos(_degToRad(stationLat)) * math.sin(dLng / 2) * math.sin(dLng / 2);

    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadiusMeters * c;
  }

  static bool isWithinStationRange({
    required double userLat,
    required double userLng,
    required double stationLat,
    required double stationLng,
  }) {
    final distance = calculateDistanceMeters(
      userLat: userLat,
      userLng: userLng,
      stationLat: stationLat,
      stationLng: stationLng,
    );
    return distance <= maxAllowedDistanceMeters;
  }

  static double _degToRad(double deg) => deg * (math.pi / 180.0);

  static String formatRelativeArabic(DateTime dateTime, {bool useQablForDays = false}) {
    final Duration diff = DateTime.now().difference(dateTime);

    if (diff.inMinutes < 1) {
      return 'الآن';
    } else if (diff.inMinutes == 1) {
      return 'منذ دقيقة';
    } else if (diff.inMinutes == 2) {
      return 'منذ دقيقتين';
    } else if (diff.inMinutes <= 10) {
      return 'منذ ${diff.inMinutes} دقائق';
    } else if (diff.inMinutes < 60) {
      return 'منذ ${diff.inMinutes} دقيقة';
    } else if (diff.inHours == 1) {
      return 'منذ ساعة';
    } else if (diff.inHours == 2) {
      return 'منذ ساعتين';
    } else if (diff.inHours < 24) {
      return 'منذ ${diff.inHours} ساعات';
    } else {
      final int days = diff.inDays;
      final String prefix = useQablForDays ? 'قبل' : 'منذ';
      if (days == 1) return useQablForDays ? 'قبل يوم' : 'منذ يوم';
      if (days == 2) return useQablForDays ? 'قبل يومين' : 'منذ يومين';
      if (days <= 10) return '$prefix $days أيام';
      return '$prefix $days يوماً';
    }
  }
}
