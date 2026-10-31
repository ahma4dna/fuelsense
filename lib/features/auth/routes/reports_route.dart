import 'package:flutter/cupertino.dart';
import 'package:fuelsense/features/auth/presentation/pages/forgot_password_screen.dart';
import 'package:fuelsense/features/auth/presentation/pages/login_screen.dart';
import 'package:fuelsense/features/auth/presentation/pages/privacy_policy_screen.dart';
import 'package:fuelsense/features/auth/presentation/pages/register_screen.dart';
import 'package:fuelsense/features/auth/presentation/pages/terms_of_use_screen.dart';
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

final termsOfUseRoute = GoRoute(
  path: termsOfUsePathe,
  name: termsOfUseName,
  pageBuilder: (context, state) {
    return CupertinoPage(
      child: TermsOfUseScreen(
        key: state.pageKey,
      ),
    );
  },
);

final privacyPolicyRoute = GoRoute(
  path: privacyPolicyPath,
  name: privacyPolicyName,
  pageBuilder: (context, state) {
    return CupertinoPage(
      child: PrivacyPolicyScreen(
        key: state.pageKey,
      ),
    );
  },
);
