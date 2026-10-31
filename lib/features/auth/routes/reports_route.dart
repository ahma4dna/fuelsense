import 'package:flutter/cupertino.dart';
import 'package:fuelsense/features/auth/presentation/pages/forgot_password_screen.dart';
import 'package:fuelsense/features/auth/presentation/pages/login_screen.dart';
import 'package:fuelsense/features/auth/presentation/pages/register_screen.dart';
import 'package:fuelsense/features/auth/presentation/pages/update_password_screen.dart';
import 'package:fuelsense/features/auth/routes/reports_path.dart';
import 'package:go_router/go_router.dart';

final authRegiterRoute = GoRoute(
  path: authRegiter,
  name: authRegiterNmae,
  pageBuilder: (context, state) => CupertinoPage(
    child: RegisterScreen(
      key: state.pageKey,
    ),
  ),
);

final authLoginRout = GoRoute(
  path: authLogin,
  name: authLoginName,
  pageBuilder: (context, state) => CupertinoPage(
    child: LoginScreen(
      key: state.pageKey,
    ),
  ),
);

final forgotPasswordRoute = GoRoute(
  path: forGotPasword,
  name: forGotPaswordName,
  pageBuilder: (context, state) {
    return CupertinoPage(
      child: ForgotPasswordScreen(
        key: state.pageKey,
      ),
    );
  },
);

final changePasswordRoute = GoRoute(
  path: changePasword,
  name: changePaswordName,
  pageBuilder: (context, state) {
    return CupertinoPage(
      child: UpdatePasswordScreen(
        key: state.pageKey,
      ),
    );
  },
);
