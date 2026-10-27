import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fuelsense/core/application/resource/app_colors.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:fuelsense/features/stations/domain/enums/report_time_line.dart';
import 'package:fuelsense/features/stations/presentation/widgets/report_screen_widget/contian_check_botton.dart';
import 'package:fuelsense/features/stations/presentation/widgets/report_screen_widget/send_report_botton.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class BuildBottomActionsReport extends StatelessWidget {
  final File? capturedImage;
  final ReportTimeLine reportTimeLine;
  final bool isCameraOpen;
  final void Function() retakePhoto;
  final void Function() takePhoto;
  final void Function() contionToAi;
  final void Function() contionToCamera;
  final void Function() contionToSendReport;
  final void Function() contionToSuccess;
  final AppContext appContext;
  const BuildBottomActionsReport({
    super.key,
    this.capturedImage,
    required this.reportTimeLine,
    required this.isCameraOpen,
    required this.retakePhoto,
    required this.takePhoto,
    required this.contionToAi,
    required this.contionToCamera,
    required this.contionToSendReport,
    required this.contionToSuccess,
    required this.appContext,
  });

  @override
  Widget build(BuildContext context) {
    if (capturedImage != null && reportTimeLine == ReportTimeLine.camera) {
      return Row(
        key: const ValueKey('action_buttons'),
        children: [
          Expanded(
            child: Container(
              height: AppSize.s56,
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(color: Color(0xB20F172A), blurRadius: 24, offset: Offset(0, 10), spreadRadius: -10),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                onPressed: retakePhoto,
                child: Text(
                  "إعادة الالتقاط",
                  style: AppStyles.getBold(
                    context: context,
                    color: AppColors.deepNavy,
                    fontSize: AppSize.s16,
                  ),
                ),
              ),
            ),
          ),
          const Gap(AppSize.s16),
          Expanded(
            child: Container(
              height: AppSize.s56,
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0xB20F172A),
                    blurRadius: 24,
                    offset: Offset(0, 10),
                    spreadRadius: -10,
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deepNavy,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: contionToAi,
                child: Text(
                  "متابعة",
                  style: AppStyles.getBold(
                    context: context,
                    color: Colors.white,
                    fontSize: AppSize.s16,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else if (isCameraOpen && reportTimeLine == ReportTimeLine.camera) {
      return Center(
        key: const ValueKey('capture_button'),
        child: GestureDetector(
          onTap: takePhoto,
          child: Container(
            height: 72,
            width: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      );
    } else if (reportTimeLine == ReportTimeLine.location) {
      return ContianCheckBotton(
        key: const ValueKey('start_camera_button'),
        title: appContext.localText.contion_check,
        onPressed: contionToCamera,
      );
    } else if (reportTimeLine == ReportTimeLine.ai) {
      return ContianCheckBotton(
        key: const ValueKey('start_camera_button_ai'),
        title: appContext.localText.contion,
        onPressed: contionToSendReport,
      );
    } else if (reportTimeLine == ReportTimeLine.sendReport) {
      return SendReportBotton(
        key: ValueKey("SendReportBotton"),
        onPressed: contionToSuccess,
        appContext: appContext,
      );
    } else {
      return ContianCheckBotton(
        key: const ValueKey('start_camera_button_success'),
        title: appContext.localText.contion,
        onPressed: () {
          context.pop();
        },
      );
    }
  }
}
