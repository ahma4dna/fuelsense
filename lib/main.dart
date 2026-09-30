import 'package:flutter/material.dart';
import 'package:fuelsense/core/application/my_app.dart';
import 'package:fuelsense/di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configDepend();
  runApp(const MyApp());
}
