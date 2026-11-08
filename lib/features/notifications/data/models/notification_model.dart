import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    super.stationId,
    required super.city,
    required super.notificationType,
    required super.title,
    required super.body,
    required super.createdAt,
    super.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: (json['id'] as num).toInt(),
      stationId: (json['station_id'] as num?)?.toInt(),
      city: (json['city'] as String?)?.trim().isNotEmpty == true ? (json['city'] as String).trim() : 'الساحل الغربي',
      notificationType: (json['notification_type'] as String?) ?? 'official',
      title: (json['title'] as String?) ?? 'لجنة التوزيع',
      body: (json['body'] as String?) ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())?.toLocal() ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
