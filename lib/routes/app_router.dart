import 'package:flutter/material.dart';
import 'package:fuelsense/di/injection.dart';
import 'package:fuelsense/features/account/routes/account_route.dart';
import 'package:fuelsense/features/auth/domain/enums/auth_enums.dart';
import 'package:fuelsense/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fuelsense/features/auth/routes/reports_path.dart';
import 'package:fuelsense/features/auth/routes/reports_route.dart';
import 'package:fuelsense/features/stations/presentation/routes/home_route.dart';
import 'package:fuelsense/features/main/routes/main_route.dart';
import 'package:fuelsense/features/reports/routes/reports_route.dart';
import 'package:fuelsense/features/staionssjs/routes/stations_route.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GoRouter router = GoRouter(
  navigatorKey: navigatorKey,
  routes: [
    authRegiterRoute,
    authLoginRout,
    homeRoute,
    stationsRoute,
    reportsRoute,
    accountRoute,
    mainRoute,
    changePasswordRoute,
    forgotPasswordRoute,
  ],
);
