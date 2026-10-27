import 'package:flutter/cupertino.dart';
import 'package:fuelsense/features/staionssjs/presentation/pages/stations_page.dart';
import 'package:fuelsense/features/staionssjs/routes/stations_path.dart';
import 'package:go_router/go_router.dart';

final stationsRoute = GoRoute(
  path: stationsPath,
  pageBuilder: (context, state) => CupertinoPage(
    child: StationsPage(
      key: state.pageKey,
    ),
  ),
);
