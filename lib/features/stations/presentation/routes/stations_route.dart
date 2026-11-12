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
  pageBuilder: (context, state) => CustomTransitionPage(
    key: state.pageKey,
    child: const StationsPage(),
    transitionDuration: const Duration(milliseconds: 450),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.98, end: 1).animate(curved),
          child: child,
        ),
      );
    },
  ),
  routes: [
    // صفحة التفاصيل: انزلاق جانبي + سحب للرجوع (Cupertino)
    GoRoute(
      path: stationHistoryPath,
      name: stationHistoryName,
      pageBuilder: (context, state) {
        final extra = state.extra as StationEntity;
        return CupertinoPage(
          key: state.pageKey,
          child: StationHistoryScreen(
            stationEntity: extra,
          ),
        );
      },
    ),
    // صفحة إضافة بلاغ: تصعد من الأسفل كنافذة مستقلة
    GoRoute(
      path: addReportScreenPath,
      name: addReportScreenName,
      pageBuilder: (context, state) {
        final (int, String, double, double) extra = state.extra as (int, String, double, double);
        return CupertinoPage(
          key: state.pageKey,
          fullscreenDialog: true,
          child: AddReportScreen(
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
