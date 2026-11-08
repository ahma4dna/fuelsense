import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuelsense/core/application/my_app.dart';
import 'package:fuelsense/core/services/app_notification_service.dart';
import 'package:fuelsense/di/injection.dart';
import 'package:fuelsense/firebase_options.dart';
import 'package:fuelsense/my_bloc_observer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://xcavszwncwszohrwmrni.supabase.co',
    publishableKey: 'sb_publishable_ZA9b7Za1VYOal2UoNCWZuw_ysQMRybj',
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await configDepend();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}
