import 'package:flutter/cupertino.dart';
import 'package:fuelsense/features/reports/presentation/pages/reports_page.dart';
import 'package:fuelsense/features/reports/routes/reports_path.dart';
import 'package:go_router/go_router.dart';

final reportsRoute = GoRoute(
  path: reportsPath,
  pageBuilder: (context, state) => CupertinoPage(
    child: ReportsPage(
      key: state.pageKey,
    ),
  ),
);
