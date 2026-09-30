import 'package:flutter/cupertino.dart';
import 'package:fuelsense/features/home/presentation/pages/home_page.dart';
import 'package:fuelsense/features/home/presentation/routes/home_path.dart';
import 'package:go_router/go_router.dart';

final homeRoute = GoRoute(
  path: homePath,
  pageBuilder: (context, state) => CupertinoPage(
    child: HomePage(
      key: state.pageKey,
    ),
  ),
);
