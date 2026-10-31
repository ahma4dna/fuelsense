import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fuelsense/core/application/resource/app_assets.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/preferences/preferences_provider.dart';
import 'package:fuelsense/di/injection.dart';
import 'package:fuelsense/features/auth/routes/reports_path.dart';
import 'package:fuelsense/features/main/routes/main_pathe.dart';
import 'package:go_router/go_router.dart';

class SplashScrenn extends StatefulWidget {
  const SplashScrenn({super.key});

  @override
  State<SplashScrenn> createState() => _SplashScrennState();
}

class _SplashScrennState extends State<SplashScrenn> with TickerProviderStateMixin {
  static const _splashDelay = Duration(milliseconds: 2600);

  late final AnimationController _introController;
  late final AnimationController _pulseController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _textOpacity;
  late final Animation<Offset> _textSlide;

  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _logoScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOutBack),
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );

    _textSlide =
        Tween<Offset>(
          begin: const Offset(0, 0.25),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _introController,
            curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    _startDelay();
  }

  void _startDelay() {
    _navigationTimer = Timer(_splashDelay, _navigateToNextScreen);
  }

  void _navigateToNextScreen() {
    if (!mounted) return;
    final hasAuthMethod = getIt<PreferencesProvider>().getAuthMethode().isNotEmpty;
    context.goNamed(hasAuthMethod ? mainPathName : authLoginName);
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _introController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _SplashColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            _AnimatedSensorDot(
              alignment: const Alignment(-0.54, -0.56),
              size: AppSize.s3_5 * 2,
              color: _SplashColors.tealDot,
              animation: _pulseController,
            ),
            _AnimatedSensorDot(
              alignment: const Alignment(0.54, 0.12),
              size: AppSize.s3_5 * 2,
              color: _SplashColors.tealDot,
              animation: _pulseController,
            ),
            _AnimatedSensorDot(
              alignment: const Alignment(0.40, -0.64),
              size: AppSize.s2_5 * 2,
              color: _SplashColors.amberDot,
              animation: _pulseController,
            ),

            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FadeTransition(
                    opacity: _logoOpacity,
                    child: ScaleTransition(
                      scale: _logoScale,
                      child: AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          final glowValue = _pulseController.value;
                          return Container(
                            padding: const EdgeInsets.all(28),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: _SplashColors.tealDot.withValues(
                                    alpha: 0.12 + (glowValue * 0.14),
                                  ),
                                  blurRadius: 40 + (glowValue * 20),
                                  spreadRadius: 4 + (glowValue * 8),
                                ),
                              ],
                            ),
                            child: child,
                          );
                        },
                        child: SvgPicture.asset(
                          AppAssets.gasStation,
                          width: AppSize.s160,
                          height: AppSize.s160,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  FadeTransition(
                    opacity: _textOpacity,
                    child: SlideTransition(
                      position: _textSlide,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.5,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Full',
                                  style: TextStyle(color: Colors.white),
                                ),
                                TextSpan(
                                  text: 'Sens',
                                  style: TextStyle(
                                    color: _SplashColors.amberDot,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 36),
                child: FadeTransition(
                  opacity: _textOpacity,
                  child: SizedBox(
                    width: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        minHeight: 3,
                        backgroundColor: _SplashColors.tealDot.withValues(alpha: 0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          _SplashColors.tealDot,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedSensorDot extends StatelessWidget {
  const _AnimatedSensorDot({
    required this.alignment,
    required this.size,
    required this.color,
    required this.animation,
  });

  final Alignment alignment;
  final double size;
  final Color color;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          final value = animation.value;
          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.5 + (value * 0.5)),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.4 * value),
                  blurRadius: 8 + (value * 6),
                  spreadRadius: value * 3,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

abstract final class _SplashColors {
  static const background = Color(0xFF0A3832);
  static const tealDot = Color(0xFF388E83);
  static const amberDot = Color(0xFFD99B26);
}
