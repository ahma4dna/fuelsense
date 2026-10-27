import 'package:flutter/material.dart';
import 'package:fuelsense/core/application/resource/app_colors.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:fuelsense/features/stations/domain/enums/report_time_line.dart';
import 'package:gap/gap.dart';

class TimeLineWidget extends StatelessWidget {
  final ReportTimeLine reportTimeLine;
  final int index;

  const TimeLineWidget({
    super.key,
    required this.reportTimeLine,
    required this.index,
  });

  final Duration _animationDuration = const Duration(milliseconds: 300);
  final Curve _animationCurve = Curves.easeInOut;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppPadding.p20,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                AnimatedContainer(
                  duration: _animationDuration,
                  curve: _animationCurve,
                  height: AppSize.s8,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00BFA6),
                    borderRadius: BorderRadius.circular(16777200),
                  ),
                ),
                const Gap(AppSize.s6),
                AnimatedDefaultTextStyle(
                  duration: _animationDuration,
                  curve: _animationCurve,
                  style: reportTimeLine == ReportTimeLine.location
                      ? AppStyles.getBold(
                          context: context,
                          color: AppColors.black,
                          fontSize: AppSize.s14,
                        )
                      : AppStyles.getMeduim(
                          context: context,
                          color: const Color(0xFF90A1B8),
                          fontSize: AppSize.s14,
                        ),
                  child: const Text("الموقع"),
                ),
              ],
            ),
          ),
          const Gap(AppSize.s6),
          Expanded(
            child: Column(
              children: [
                AnimatedContainer(
                  duration: _animationDuration,
                  curve: _animationCurve,
                  height: AppSize.s8,
                  decoration: BoxDecoration(
                    color: reportTimeLine.index >= ReportTimeLine.camera.index
                        ? const Color(0xFF00BFA6)
                        : const Color(0xFFE1E8F0),
                    borderRadius: BorderRadius.circular(16777200),
                  ),
                ),
                const Gap(AppSize.s6),
                AnimatedDefaultTextStyle(
                  duration: _animationDuration,
                  curve: _animationCurve,
                  style: reportTimeLine == ReportTimeLine.camera
                      ? AppStyles.getBold(
                          context: context,
                          color: AppColors.black,
                          fontSize: AppSize.s14,
                        )
                      : AppStyles.getMeduim(
                          context: context,
                          color: const Color(0xFF90A1B8),
                          fontSize: AppSize.s14,
                        ),
                  child: const Text("الكاميرا"),
                ),
              ],
            ),
          ),
          const Gap(AppSize.s6),
          Expanded(
            child: Column(
              children: [
                AnimatedContainer(
                  duration: _animationDuration,
                  curve: _animationCurve,
                  height: AppSize.s8,
                  decoration: BoxDecoration(
                    color: reportTimeLine.index >= ReportTimeLine.ai.index
                        ? const Color(0xFF00BFA6)
                        : const Color(0xFFE1E8F0),
                    borderRadius: BorderRadius.circular(16777200),
                  ),
                ),
                const Gap(AppSize.s6),
                AnimatedDefaultTextStyle(
                  duration: _animationDuration,
                  curve: _animationCurve,
                  style: reportTimeLine == ReportTimeLine.ai
                      ? AppStyles.getBold(
                          context: context,
                          color: AppColors.black,
                          fontSize: AppSize.s14,
                        )
                      : AppStyles.getMeduim(
                          context: context,
                          color: const Color(0xFF90A1B8),
                          fontSize: AppSize.s14,
                        ),
                  child: const Text('تحليل AI'),
                ),
              ],
            ),
          ),
          const Gap(AppSize.s6),
          Expanded(
            child: Column(
              children: [
                AnimatedContainer(
                  duration: _animationDuration,
                  curve: _animationCurve,
                  height: AppSize.s8,
                  decoration: BoxDecoration(
                    color: reportTimeLine.index >= ReportTimeLine.sendReport.index
                        ? const Color(0xFF00BFA6)
                        : const Color(0xFFE1E8F0),
                    borderRadius: BorderRadius.circular(16777200),
                  ),
                ),
                const Gap(AppSize.s6),
                AnimatedDefaultTextStyle(
                  duration: _animationDuration,
                  curve: _animationCurve,
                  style: reportTimeLine == ReportTimeLine.sendReport
                      ? AppStyles.getBold(
                          context: context,
                          color: AppColors.black,
                          fontSize: AppSize.s14,
                        )
                      : AppStyles.getMeduim(
                          context: context,
                          color: const Color(0xFF90A1B8),
                          fontSize: AppSize.s14,
                        ),
                  child: const Text('البلاغ'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
