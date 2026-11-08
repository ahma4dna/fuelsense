import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/notification_model.dart';

abstract class NotificationsRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();
  Stream<void> watchNotificationsStream();
}

@LazySingleton(as: NotificationsRemoteDataSource)
class NotificationsRemoteDataSourceImpl implements NotificationsRemoteDataSource {
  final SupabaseClient _supabase;

  NotificationsRemoteDataSourceImpl(this._supabase);

  @override
  Future<List<NotificationModel>> getNotifications() async {
    final response = await _supabase.from('notifications').select().order('created_at', ascending: false).limit(80);

    return (response as List<dynamic>).map((row) => NotificationModel.fromJson(row as Map<String, dynamic>)).toList();
  }

  @override
  Stream<void> watchNotificationsStream() {
    final controller = StreamController<void>.broadcast();

    final channel = _supabase
        .channel('public:notifications_screen_sync')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'notifications',
          callback: (_) => controller.add(null),
        )
        .subscribe();

    controller.onCancel = () {
      _supabase.removeChannel(channel);
    };

    return controller.stream;
  }
}
