import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final int id;
  final int? stationId;
  final String city;
  final String notificationType;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;

  const NotificationEntity({
    required this.id,
    this.stationId,
    required this.city,
    required this.notificationType,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isRead = false,
  });

  NotificationEntity copyWith({bool? isRead}) {
    return NotificationEntity(
      id: id,
      stationId: stationId,
      city: city,
      notificationType: notificationType,
      title: title,
      body: body,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
    );
  }

  String get resolvedStatusCategory {
    final type = notificationType.toLowerCase();
    if (type == 'open' || body.contains('باشرت') || body.contains('توزيع')) {
      return 'open';
    }
    if (type == 'refilling' || body.contains('تفريغ')) {
      return 'refilling';
    }
    if (type == 'on_the_way' || body.contains('في الطريق')) {
      return 'on_the_way';
    }
    if (type == 'out_of_fuel' || body.contains('نفد')) {
      return 'out_of_fuel';
    }
    return 'official';
  }

  @override
  List<Object?> get props => [
    id,
    stationId,
    city,
    notificationType,
    title,
    body,
    createdAt,
    isRead,
  ];
}
