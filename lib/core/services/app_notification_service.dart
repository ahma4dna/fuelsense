import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (message.notification == null && message.data.isNotEmpty) {
    final plugin = FlutterLocalNotificationsPlugin();
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    await plugin.initialize(
      settings: const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );

    const androidDetails = AndroidNotificationDetails(
      'fuelsense_high_importance_channel',
      'إشعارات توفر الوقود (FuelSense)',
      channelDescription: 'تنبيهات لحظية عند فتح المحطات أو وصول طلبيات الوقود',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      enableVibration: true,
    );

    await plugin.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: message.data['title']?.toString() ?? 'تحديث لجنة التوزيع',
      body: message.data['body']?.toString() ?? '',
      notificationDetails: const NotificationDetails(android: androidDetails),
      payload: message.data['station_id']?.toString(),
    );
  }
}

@lazySingleton
class AppNotificationService {
  final SupabaseClient _supabase;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  RealtimeChannel? _notificationsChannel;
  StreamSubscription<String>? _tokenRefreshSub;
  StreamSubscription<AuthState>? _authStateSub;
  StreamSubscription<RemoteMessage>? _foregroundMessageSub;
  StreamSubscription<RemoteMessage>? _messageOpenedAppSub;

  void Function(int? stationId)? _onNotificationTapped;
  bool _isInitialized = false;

  String? _lastShownBody;
  DateTime? _lastShownTime;

  AppNotificationService(this._supabase);

  Future<void> initialize({
    void Function(int? stationId)? onNotificationTapped,
  }) async {
    _onNotificationTapped = onNotificationTapped;
    if (_isInitialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload != null && _onNotificationTapped != null) {
          _onNotificationTapped!(int.tryParse(payload));
        }
      },
    );

    final androidPlatform = _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidPlatform?.requestNotificationsPermission();

    const androidChannel = AndroidNotificationChannel(
      'fuelsense_high_importance_channel',
      'إشعارات توفر الوقود (FuelSense)',
      description: 'تنبيهات لحظية عند فتح المحطات أو وصول طلبيات الوقود',
      importance: Importance.max,
      playSound: true,
    );
    await androidPlatform?.createNotificationChannel(androidChannel);

    await _setupFirebaseMessaging();

    _startListeningToSupabaseNotifications();

    _isInitialized = true;
  }

  Future<void> _setupFirebaseMessaging() async {
    try {
      //
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        debugPrint('[FCM] User declined notification permissions');
        return;
      }

      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      await _firebaseMessaging.subscribeToTopic('fuelsense_alerts');

      await _syncFcmTokenWithSupabase();

      _tokenRefreshSub = _firebaseMessaging.onRegistered.listen((newToken) {
        _saveTokenToDatabase(newToken);
      });

      _authStateSub = _supabase.auth.onAuthStateChange.listen((authState) {
        if (authState.event == AuthChangeEvent.signedIn || authState.event == AuthChangeEvent.tokenRefreshed) {
          _syncFcmTokenWithSupabase();
        }
      });

      _foregroundMessageSub = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        final title = message.notification?.title ?? message.data['title']?.toString() ?? 'تحديث لجنة التوزيع';
        final body = message.notification?.body ?? message.data['body']?.toString() ?? '';
        final stationId = message.data['station_id']?.toString();

        if (body.isNotEmpty) {
          showInstantNotification(
            id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
            title: title,
            body: body,
            payload: stationId,
          );
        }
      });

      _messageOpenedAppSub = FirebaseMessaging.onMessageOpenedApp.listen(_handleRemoteMessageTap);

      // عند فتح التطبيق من الصفر (Terminated) عبر الضغط على إشعار FCM
      final initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        _handleRemoteMessageTap(initialMessage);
      }
    } catch (e) {
      debugPrint('[FCM] Setup warning: $e');
    }
  }

  /// جلب التوكن من Firebase وحفظه في جدول profiles
  Future<void> _syncFcmTokenWithSupabase() async {
    try {
      final token = await _firebaseMessaging.getToken();
      if (token != null && token.isNotEmpty) {
        await _saveTokenToDatabase(token);
      }
    } catch (e) {
      debugPrint('[FCM] Error getting token: $e');
    }
  }

  /// حفظ أو تحديث fcm_token للمستخدم الحالي في جدول profiles
  Future<void> _saveTokenToDatabase(String token) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      await _supabase
          .from('profiles')
          .update({
            'fcm_token': token,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);
      debugPrint('[FCM] Token saved/updated successfully for user: $userId');
    } catch (e) {
      debugPrint('[FCM] Failed to update token in profiles: $e');
    }
  }

  void _handleRemoteMessageTap(RemoteMessage message) {
    final stationIdStr = message.data['station_id']?.toString();
    if (stationIdStr != null && _onNotificationTapped != null) {
      _onNotificationTapped!(int.tryParse(stationIdStr));
    }
  }

  void _startListeningToSupabaseNotifications() {
    _notificationsChannel = _supabase
        .channel('public:notifications_live_alerts')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'notifications',
          callback: (payload) {
            final newRow = payload.newRecord;
            if (newRow.isEmpty) return;

            final id = (newRow['id'] as num?)?.toInt() ?? DateTime.now().millisecondsSinceEpoch ~/ 1000;
            final title = (newRow['title'] as String?) ?? 'تحديث لجنة التوزيع';
            final body = (newRow['body'] as String?) ?? '';
            final stationId = newRow['station_id']?.toString();

            if (body.isNotEmpty) {
              showInstantNotification(
                id: id,
                title: title,
                body: body,
                payload: stationId,
              );
            }
          },
        )
        .subscribe();
  }

  Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    final now = DateTime.now();
    if (_lastShownBody == body && _lastShownTime != null && now.difference(_lastShownTime!).inSeconds < 8) {
      return;
    }
    _lastShownBody = body;
    _lastShownTime = now;

    const androidDetails = AndroidNotificationDetails(
      'fuelsense_high_importance_channel',
      'إشعارات توفر الوقود (FuelSense)',
      channelDescription: 'تنبيهات لحظية عند فتح المحطات أو وصول طلبيات الوقود',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }

  void dispose() {
    _tokenRefreshSub?.cancel();
    _authStateSub?.cancel();
    _foregroundMessageSub?.cancel();
    _messageOpenedAppSub?.cancel();
    if (_notificationsChannel != null) {
      _supabase.removeChannel(_notificationsChannel!);
    }
  }
}
