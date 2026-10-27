import 'package:flutter/material.dart';
import 'package:fuelsense/features/account/routes/account_route.dart';
import 'package:fuelsense/features/stations/presentation/routes/home_route.dart';
import 'package:fuelsense/features/main/routes/main_route.dart';
import 'package:fuelsense/features/reports/routes/reports_route.dart';
import 'package:fuelsense/features/staionssjs/routes/stations_route.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GoRouter router = GoRouter(
  navigatorKey: navigatorKey,
  routes: [
    homeRoute,
    stationsRoute,
    reportsRoute,
    accountRoute,
    mainRoute,
  ],
);
