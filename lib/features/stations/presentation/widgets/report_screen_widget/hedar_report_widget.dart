import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fuelsense/core/application/resource/app_assets.dart';
import 'package:fuelsense/core/application/resource/app_colors.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:fuelsense/features/stations/domain/enums/report_time_line.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class HedarReportWidget extends StatelessWidget {
  const HedarReportWidget({
    super.key,
    required this.appContext,
    required this.reportTimeLine,
    required this.isOpenCamera,
  });

  final AppContext appContext;
  final ReportTimeLine reportTimeLine;
  final bool isOpenCamera;

  String getTitle(ReportTimeLine reportTimeLine, AppContext appContex) {
    switch (reportTimeLine) {
      case ReportTimeLine.location:
        return appContex.localText.check_location;
      case ReportTimeLine.camera:
        return appContex.localText.camera_shot;
      case ReportTimeLine.ai:
        return appContex.localText.shot_ai;
      case ReportTimeLine.sendReport:
        return appContex.localText.send_report;
      case ReportTimeLine.success:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppSize.s44,
          height: AppSize.s44,
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
            border: Border.all(
              width: 1,
              color: AppColors.border,
            ),
          ),
          child: GestureDetector(
            onTap: () {
              context.pop();
            },
            child: Center(
              child: SvgPicture.asset(
                AppAssets.back,
                width: AppSize.s22,
                height: AppSize.s22,
              ),
            ),
          ),
        ),
        const Gap(AppSize.s12),
        AnimatedDefaultTextStyle(
          style: AppStyles.getBold(
            color: isOpenCamera ? AppColors.white : const Color(0xFF0F172A),
            fontSize: AppSize.s18,
            context: context,
          ),
          duration: Duration(milliseconds: 300),
          child: Text(
            getTitle(reportTimeLine, appContext),
          ),
        ),
      ],
    );
  }
}
