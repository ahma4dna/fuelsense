import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fuelsense/core/application/resource/app_colors.dart';
import 'package:fuelsense/core/preferences/preferences_provider.dart';
import 'package:fuelsense/di/injection.dart';
import 'package:fuelsense/features/auth/routes/reports_path.dart';
import 'package:fuelsense/features/main/routes/main_pathe.dart';
import 'package:go_router/go_router.dart';

class SplashScrenn extends StatefulWidget {
  const new({super.key});

  @override
  State<SplashScrenn> createState() => _SplashScrennState();
}

class _SplashScrennState extends State<SplashScrenn> {
  Timer? _timer;
  void _statrtDeley() {
    _timer = Timer(Duration(milliseconds: 300), _navigateTo);
  }

  void _navigateTo() {
    if (getIt<PreferencesProvider>().getAuthMethode().isNotEmpty) {
      context.goNamed(mainPathName);
    } else {
      context.goNamed(authLoginName);
    }
  }

  @override
  void initState() {
    super.initState();
    _statrtDeley();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
    );
  }
}
