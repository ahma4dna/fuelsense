import 'package:flutter/cupertino.dart';
import 'package:fuelsense/features/home/data/models/station_model.dart';
import 'package:fuelsense/features/home/presentation/pages/home_page.dart';
import 'package:fuelsense/features/home/presentation/pages/report_screen.dart';
import 'package:fuelsense/features/home/presentation/pages/station_details.dart';
import 'package:fuelsense/features/home/presentation/routes/home_path.dart';
import 'package:go_router/go_router.dart';

final homeRoute = GoRoute(
  path: homePath,
  name: homeName,
  pageBuilder: (context, state) => CupertinoPage(
    child: HomePage(
      key: state.pageKey,
    ),
  ),
  routes: [
    GoRoute(
      path: stationDetailsPath,
      name: stationDetailsName,
      pageBuilder: (context, state) {
        final extra = state.extra as StationModel?;
        return CupertinoPage(
          child: StationDetails(
            stationModel: extra,
            key: state.pageKey,
          ),
        );
      },
    ),
    GoRoute(
      path: reportPathe,
      name: reportName,
      pageBuilder: (context, state) {
        return CupertinoPage(
          child: ReportScreen(
            key: state.pageKey,
          ),
        );
      },
    ),
  ],
);
