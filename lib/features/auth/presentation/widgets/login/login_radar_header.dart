import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fuelsense/core/application/resource/app_assets.dart';
import 'package:fuelsense/core/application/resource/app_colors.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';

import 'package:gap/gap.dart';

class LoginRadarHeader extends StatelessWidget {
  const LoginRadarHeader({super.key});
  @override
  Widget build(BuildContext context) {
    final appContext = AppContext.of(context);
    return SizedBox(
      height: AppSize.s290,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _RadarCirclesPainter(),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Icon
                SvgPicture.asset(
                  AppAssets.gasStation,
                  width: AppSize.s120,
                  height: AppSize.s120,
                ),
                const Gap(AppSize.s18),
                // Welcome
                Text(
                  appContext.localText.welcome_back,
                  style: AppStyles.getExtraBold(
                    context: context,
                    fontSize: AppSize.s28,
                    color: AppColors.white,
                  ),
                ),
                const Gap(AppSize.s6),
                Text(
                  appContext.localText.login_subtitle,
                  style: AppStyles.getMeduim(
                    context: context,
                    fontSize: AppSize.s14_5,
                    color: const Color(0xFFAEC7C3),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RadarCirclesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height * 0.43,
    );
    final circlePaint = Paint()
      ..color = const Color(0xFF1E554E).withValues(alpha: 0.38)
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppSize.s1;
    for (final radius in [
      68.0,
      115.0,
      165.0,
      220.0,
    ]) {
      canvas.drawCircle(center, radius, circlePaint);
    }
    // Radar Points
    final tealDotPaint = Paint()..color = const Color(0xFF388E83);
    final amberDotPaint = Paint()..color = const Color(0xFFD99B26);
    canvas.drawCircle(
      Offset(size.width * 0.23, size.height * 0.22),
      AppSize.s3_5,
      tealDotPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.77, size.height * 0.56),
      AppSize.s3_5,
      tealDotPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.70, size.height * 0.18),
      AppSize.s2_5,
      amberDotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
