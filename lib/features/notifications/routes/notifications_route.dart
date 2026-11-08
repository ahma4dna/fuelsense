import 'package:flutter/cupertino.dart';
import 'package:fuelsense/features/notifications/presentation/pages/notifications_screen.dart';
import 'package:fuelsense/features/notifications/routes/notifications_path.dart';
import 'package:go_router/go_router.dart';

final notificationsRoute = GoRoute(
  path: notificationsPath,
  name: notificationsName,
  pageBuilder: (context, state) => CupertinoPage(
    child: NotificationsScreen(
      key: state.pageKey,
    ),
  ),
);
