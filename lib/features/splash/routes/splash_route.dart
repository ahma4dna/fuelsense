import 'package:flutter/cupertino.dart';
import 'package:fuelsense/features/splash/routes/splash_route_path.dart';
import 'package:fuelsense/features/splash/splash_screnn.dart';
import 'package:go_router/go_router.dart';

final splashRoute = GoRoute(
  path: splashRoutePath,
  name: splashRouteName,

  pageBuilder: (context, state) {
    return CupertinoPage(
      child: SplashScrenn(
        key: state.pageKey,
      ),
    );
  },
);
