import 'package:flutter/cupertino.dart';
import 'package:fuelsense/features/stations_directory/presentation/pages/stations_directory_screen.dart';
import 'package:fuelsense/features/stations_directory/routes/stations_directory_path.dart';
import 'package:go_router/go_router.dart';

final stationsDirectoryRoute = GoRoute(
  path: stationsDirectoryPath,
  name: stationsNirectoryName,
  pageBuilder: (context, state) => CupertinoPage(
    child: StationsDirectoryScreen(
      key: state.pageKey,
    ),
  ),
);
