import 'package:flutter/cupertino.dart';
import 'package:fuelsense/features/stations/domain/entities/station_entity.dart';
import 'package:fuelsense/features/stations/presentation/pages/home_page.dart';
import 'package:fuelsense/features/stations/presentation/pages/station_history_screen.dart';
import 'package:fuelsense/features/stations/presentation/routes/home_path.dart';
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
      path: stationHistoryPath,
      name: stationHistoryName,
      pageBuilder: (context, state) {
        final extra = state.extra as StationEntity;
        return CupertinoPage(
          child: StationHistoryScreen(
            stationEntity: extra,
            key: state.pageKey,
          ),
        );
      },
    ),
    // GoRoute(
    //   path: reportPathe,
    //   name: reportName,
    //   pageBuilder: (context, state) {
    //     return CupertinoPage(
    //       child: ReportScreen(
    //         key: state.pageKey,
    //       ),
    //     );
    //   },
    // ),
  ],
);
