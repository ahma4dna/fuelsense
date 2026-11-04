import 'package:flutter/material.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/features/stations/domain/entities/field_report_entity.dart';
import 'package:fuelsense/features/stations/domain/enums/station_enums.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fuelsense/core/application/resource/app_assets.dart';
import 'package:fuelsense/core/application/resource/app_colors.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:fuelsense/features/stations/domain/extensions/station_extensions.dart';
import 'package:gap/gap.dart';

class ReportWidget extends StatelessWidget {
  const ReportWidget({
    super.key,
    required this.appContext,
    required this.report,
  });

  final AppContext appContext;
  final FieldReportEntity report;

  Color _getQueueDotColor(QueueLevel level) {
    switch (level) {
      case QueueLevel.light:
        return const Color(0xFF16A34A);
      case QueueLevel.medium:
        return const Color(0xFFEAB308);
      case QueueLevel.heavy:
        return const Color(0xFFD92D20);
      case QueueLevel.stopped:
        return const Color(0xFF7B8886);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPadding.p14),
      margin: const EdgeInsets.symmetric(
        horizontal: AppPadding.p20,
      ),
      decoration: ShapeDecoration(
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppSize.s18),
            topRight: Radius.circular(AppSize.s6),
            bottomLeft: Radius.circular(AppSize.s18),
            bottomRight: Radius.circular(AppSize.s18),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                AppAssets.userAvatar,
                height: AppSize.s40,
                width: AppSize.s40,
              ),
              const Gap(AppSize.s10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //name user
                    Text(
                      report.nameUer,
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: AppStyles.getExtraBold(
                        context: context,
                        color: const Color(0xFF11201F),
                        fontSize: AppSize.s14,
                      ),
                    ),
                    //date report
                    Text(
                      report.createdAtRelativeText,
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: AppStyles.getMeduim(
                        context: context,
                        color: const Color(0xFF7B8886),
                        fontSize: AppSize.s12,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.p8,
                    vertical: AppPadding.p4,
                  ),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFFAF9F6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSize.s10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: ShapeDecoration(
                          color: _getQueueDotColor(report.queueStatus),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16777200),
                          ),
                        ),
                      ),
                      const Gap(AppSize.s5),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            report.queueStatus.arabicLabel,
                            maxLines: 1,
                            style: AppStyles.getBold(
                              context: context,
                              color: const Color(0xFF11201F),
                              fontSize: AppSize.s12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Gap(AppSize.s10),
          Text(
            (report.note != null && report.note!.trim().isNotEmpty) ? report.note! : report.queueStatus.arabicLabel,
            maxLines: 2,
            overflow: TextOverflow.clip,
            style: AppStyles.getMeduim(
              context: context,
              color: const Color(0xFF11201F),
              fontSize: AppSize.s15,
            ),
          ),
          const Gap(AppSize.s10),
          // Container(
          //   padding: const EdgeInsets.symmetric(
          //     horizontal: AppPadding.p12,
          //     vertical: AppPadding.p10,
          //   ),
          //   decoration: ShapeDecoration(
          //     color: const Color(0xFFEEF9F7),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(12),
          //     ),
          //   ),
          //   child: Row(
          //     children: [
          //       InkWell(
          //         onTap: () {},
          //         child: Icon(
          //           Icons.thumb_up_outlined,
          //           color: AppColors.primary,
          //           size: AppSize.s22,
          //         ),
          //       ),
          //       const Gap(AppSize.s6),
          //       Expanded(
          //         child: RichText(
          //           text: TextSpan(
          //             style: AppStyles.getBold(
          //               context: context,
          //               color: const Color(0xFF083A38),
          //               fontSize: AppSize.s13,
          //             ),
          //             children: [
          //               TextSpan(
          //                 text: appContext.localText.submit_report_user,
          //               ),
          //               TextSpan(
          //                 text: _getConfirmationDetailsText(),
          //                 style: AppStyles.getMeduim(
          //                   context: context,
          //                   color: const Color(0xFF4A5957),
          //                   fontSize: AppSize.s13,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
