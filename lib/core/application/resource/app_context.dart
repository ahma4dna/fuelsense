import 'package:flutter/material.dart';
import 'package:fuelsense/l10n/app_localizations.dart';

class AppContext {
  final bool isDark;

  final bool isRt;

  final AppLocalizations localText;
  final String local;

  AppContext({required this.isDark, required this.isRt, required this.local, required this.localText});

  factory AppContext.of(BuildContext context) {
    return AppContext(
      isDark: Theme.of(context).brightness == Brightness.dark,
      isRt: Directionality.of(context) == TextDirection.rtl,
      localText: AppLocalizations.of(context)!,
      local: Localizations.localeOf(context).languageCode,
    );
  }
}
