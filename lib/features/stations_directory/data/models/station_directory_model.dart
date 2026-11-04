import '../../domain/entities/station_directory_entity.dart';

class StationDirectoryModel extends StationDirectoryEntity {
  const StationDirectoryModel({
    required super.id,
    required super.name,
    required super.city,
    required super.latitude,
    required super.longitude,
    required super.status,
    required super.queueStatus,
    super.trafficDelayRatio,
    super.todayReportsCount,
    required super.updatedAt,
    super.distanceInMeters,
  });

  factory StationDirectoryModel.fromJson(
    Map<String, dynamic> json, {
    int todayReportsCount = 0,
    String? dominantTodayQueue,
  }) {
    final rawStatus = (json['status'] as String?)?.toLowerCase() ?? 'closed';
    final normalizedStatus = switch (rawStatus) {
      'open' || 'available' => 'open',
      'refilling' || 'unloading' => 'refilling',
      'on_the_way' || 'in_transit' => 'on_the_way',
      _ => 'closed',
    };

    final rawQueue = dominantTodayQueue ?? (json['queue_status'] as String?)?.toLowerCase() ?? 'light';

    return StationDirectoryModel(
      id: (json['id'] as num).toInt(),
      name: (json['name'] as String?) ?? 'محطة وقود',
      city: (json['city'] as String?)?.trim().isNotEmpty == true ? (json['city'] as String) : 'الساحل الغربي',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      status: normalizedStatus,
      queueStatus: rawQueue,
      trafficDelayRatio: (json['traffic_delay_ratio'] as num?)?.toInt() ?? 0,
      todayReportsCount: todayReportsCount,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
