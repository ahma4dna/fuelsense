import 'package:flutter/material.dart';
import 'package:fuelsense/core/application/theme/light_theme.dart';
import 'package:fuelsense/l10n/app_localizations.dart';
import 'package:fuelsense/routes/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      locale: Locale("ar"),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: LightTheme.lightTheme(context: context),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
