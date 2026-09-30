import 'package:flutter/cupertino.dart';
import 'package:fuelsense/features/account/presentation/pages/account_page.dart';
import 'package:fuelsense/features/account/routes/account_path.dart';
import 'package:go_router/go_router.dart';

final accountRoute = GoRoute(
  path: accountPath,
  pageBuilder: (context, state) => CupertinoPage(
    child: AccountPage(
      key: state.pageKey,
    ),
  ),
);
