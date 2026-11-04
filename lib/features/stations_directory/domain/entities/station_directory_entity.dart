import 'package:equatable/equatable.dart';

class StationDirectoryEntity extends Equatable {
  final int id;
  final String name;
  final String city;
  final double latitude;
  final double longitude;
  final String status; // 'open', 'refilling', 'on_the_way', 'closed'
  final String queueStatus; // 'light', 'medium', 'heavy', 'stopped'
  final int trafficDelayRatio;
  final int todayReportsCount;
  final DateTime updatedAt;
  final double? distanceInMeters;

  const StationDirectoryEntity({
    required this.id,
    required this.name,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.queueStatus,
    this.trafficDelayRatio = 0,
    this.todayReportsCount = 0,
    required this.updatedAt,
    this.distanceInMeters,
  });

  StationDirectoryEntity copyWith({
    double? distanceInMeters,
  }) {
    return StationDirectoryEntity(
      id: id,
      name: name,
      city: city,
      latitude: latitude,
      longitude: longitude,
      status: status,
      queueStatus: queueStatus,
      trafficDelayRatio: trafficDelayRatio,
      todayReportsCount: todayReportsCount,
      updatedAt: updatedAt,
      distanceInMeters: distanceInMeters ?? this.distanceInMeters,
    );
  }

  String get statusBadgeText {
    switch (status) {
      case 'open':
        return 'مفتوحة وتعمل';
      case 'refilling':
        return 'يتم تفريغ الطلبية ';
      case 'on_the_way':
        return 'الطلبية في الطريق للمحطة';
      default:
        return 'غير معروفة حالياً';
    }
  }

  int get trafficSeverityLevel {
    if (trafficDelayRatio >= 45 || queueStatus == 'heavy' || queueStatus == 'stopped') {
      return 3;
    }
    if (trafficDelayRatio >= 20 || queueStatus == 'medium') {
      return 2;
    }
    return 1;
  }

  String get trafficStatusText {
    return switch (trafficSeverityLevel) {
      3 => 'ازدحام شديد أمام المحطة',
      2 => 'حركة سير متوسطة الكثافة',
      _ => 'سير طبيعي',
    };
  }

  String get queueLabelText {
    return switch (queueStatus) {
      'light' => 'الطابور خفيف',
      'medium' => 'الطابور متوسط',
      'heavy' => 'الطابور مزدحم جداً',
      'stopped' => 'الطابور متوقف',
      _ => 'الطابور خفيف',
    };
  }

  int get crowdingScore {
    final queueWeight = switch (queueStatus) {
      'light' => 10,
      'medium' => 30,
      'heavy' => 70,
      'stopped' => 90,
      _ => 20,
    };
    final statusPenalty = (status == 'closed') ? 200 : 0;
    return statusPenalty + queueWeight + trafficDelayRatio;
  }

  @override
  List<Object?> get props => [
    id,
    name,
    city,
    latitude,
    longitude,
    status,
    queueStatus,
    trafficDelayRatio,
    todayReportsCount,
    updatedAt,
    distanceInMeters,
  ];
}
