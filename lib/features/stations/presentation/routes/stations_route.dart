import 'package:flutter/cupertino.dart';
import 'package:fuelsense/features/stations/domain/entities/station_entity.dart';
import 'package:fuelsense/features/stations/presentation/pages/add_report_screen.dart';
import 'package:fuelsense/features/stations/presentation/pages/stations_page.dart';
import 'package:fuelsense/features/stations/presentation/pages/station_history_screen.dart';
import 'package:fuelsense/features/stations/presentation/routes/stations_path.dart';
import 'package:go_router/go_router.dart';

final stationsRoute = GoRoute(
  path: stationsPath,
  name: stationsName,
  pageBuilder: (context, state) => CupertinoPage(
    child: StationsPage(
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
    GoRoute(
      path: addReportScreenPath,
      name: addReportScreenName,
      pageBuilder: (context, state) {
        final (int, String, double, double) extra = state.extra as (int, String, double, double);
        return CupertinoPage(
          child: AddReportScreen(
            key: state.pageKey,
            stationId: extra.$1,
            stationName: extra.$2,
            stationLatitude: extra.$3,
            stationLongitude: extra.$4,
          ),
        );
      },
    ),
  ],
);
