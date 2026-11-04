import 'package:flutter/material.dart';
import 'package:fuelsense/features/account/routes/account_route.dart';
import 'package:fuelsense/features/auth/routes/reports_route.dart';
import 'package:fuelsense/features/splash/routes/splash_route.dart';
import 'package:fuelsense/features/stations/presentation/routes/stations_route.dart';
import 'package:fuelsense/features/main/routes/main_route.dart';
import 'package:fuelsense/features/reports/routes/reports_route.dart';
import 'package:fuelsense/features/stations_directory/routes/stations_directory_route.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GoRouter router = GoRouter(
  navigatorKey: navigatorKey,
  routes: [
    authRegiterRoute,
    authLoginRout,
    stationsRoute,
    reportsRoute,
    accountRoute,
    mainRoute,
    changePasswordRoute,
    forgotPasswordRoute,
    splashRoute,
    termsOfUseRoute,
    privacyPolicyRoute,
    stationsDirectoryRoute,
  ],
);
