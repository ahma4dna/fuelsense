import 'package:flutter/cupertino.dart';
import 'package:fuelsense/features/main/presentaion/screens/main_screen.dart';
import 'package:fuelsense/features/main/routes/main_pathe.dart';
import 'package:go_router/go_router.dart';

final mainRoute = GoRoute(
  pageBuilder: (context, state) {
    return CupertinoPage(
      child: MainScreen(),
    );
  },
  path: mainPathe,
  name: mainPathName,
);
