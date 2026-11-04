import 'package:flutter/cupertino.dart';
import 'package:fuelsense/features/stations/presentation/pages/stations_page.dart';
import 'package:go_router/go_router.dart';

final stationsRoute = GoRoute(
  path: "",
  pageBuilder: (context, state) => CupertinoPage(
    child: StationsPage(
      key: state.pageKey,
    ),
  ),
);
