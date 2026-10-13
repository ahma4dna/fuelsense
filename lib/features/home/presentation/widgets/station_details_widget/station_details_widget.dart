import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fuelsense/core/application/resource/app_assets.dart';
import 'package:fuelsense/core/application/resource/app_colors.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:fuelsense/core/utils/location_service.dart';
import 'package:fuelsense/features/home/data/models/station_model.dart';
import 'package:fuelsense/features/home/presentation/pages/station_details.dart';
import 'package:gap/gap.dart';

class StationDetailsWidget extends StatelessWidget {
  const StationDetailsWidget({
    super.key,
    required this.widget,
    required this.appContext,
    this.stationModel,
  });

  final StationDetails widget;
  final AppContext appContext;
  final StationModel? stationModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSize.s20),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 2,
            offset: Offset(0, 1),
            spreadRadius: -1,
          ),
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 3,
            offset: Offset(0, 1),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color(0xB2E1E8F0),
            blurRadius: 0,
            offset: Offset(0, 0),
            spreadRadius: 1,
          ),
        ],
        borderRadius: BorderRadius.circular(AppSize.s22),
        border: Border.all(
          width: 1,
          color: AppColors.border,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.stationModel?.name ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                  style: AppStyles.getExtraBold(
                    context: context,
                    color: const Color(0xFF0F172A),
                    fontSize: AppSize.s20,
                  ),
                ),
              ),
              const Gap(AppSize.s10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: ShapeDecoration(
                  color: widget.stationModel?.statusLabelColor.withValues(alpha: 0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: AppSize.s10,
                      height: AppSize.s10,
                      decoration: ShapeDecoration(
                        color: widget.stationModel?.statusLabelColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSize.s100),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      widget.stationModel?.statusLabel ?? "",
                      style: AppStyles.getBold(
                        color: widget.stationModel?.statusLabelColor,
                        fontSize: AppSize.s14,
                        context: context,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(AppSize.s20),
          Flexible(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Stack(
                    alignment: AlignmentGeometry.center,
                    children: [
                      SizedBox(
                        width: AppSize.s132,
                        height: AppSize.s132,
                        child: CircularProgressIndicator(
                          strokeWidth: 14,
                          value: widget.stationModel?.currentProbability ?? 0,
                          color: widget.stationModel?.statusLabelColor,
                          backgroundColor: const Color(0XFFE2E7F1),
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      SizedBox(
                        width: AppSize.s132,
                        height: AppSize.s132,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      '100/',
                                      overflow: TextOverflow.fade,
                                      style: AppStyles.getBold(
                                        context: context,
                                        color: const Color(0xFF90A1B8),
                                        fontSize: AppSize.s18,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      ((widget.stationModel?.currentProbability ?? 0) * 100).toStringAsFixed(
                                        0,
                                      ),
                                      overflow: TextOverflow.fade,
                                      style: AppStyles.getExtraBold(
                                        context: context,
                                        color: const Color(0xFF0F172A),
                                        fontSize: AppSize.s38,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Flexible(
                              child: Text(
                                appContext.localText.confdance_prob,
                                overflow: TextOverflow.fade,
                                style: AppStyles.getMeduim(
                                  context: context,
                                  color: const Color(0xFF61738D),
                                  fontSize: AppSize.s12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(AppSize.s20),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      Flexible(
                        child: Text(
                          widget.stationModel?.confidance ?? "",
                          style: AppStyles.getBold(
                            context: context,
                            color: const Color(0xFF0F172A),
                            fontSize: AppSize.s16,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          'مبني على 12 بلاغاً موثقاً خلال آخر ساعتين.',

                          style: AppStyles.getRgular(
                            context: context,
                            color: const Color(0xFF61738D),
                            fontSize: AppSize.s13,
                          ),
                        ),
                      ),
                      const Gap(AppSize.s20),
                      Container(
                        height: AppSize.s48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: const Color(0xFF0F172A),

                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xB20F172A),
                              blurRadius: AppSize.s24,
                              offset: Offset(AppSize.s0, AppSize.s10),
                              spreadRadius: -AppSize.s10,
                            ),
                          ],
                        ),
                        child: Material(
                          color: const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(18),
                          child: InkWell(
                            onTap: () async {
                              await LocationService.openMap(
                                latitude: stationModel?.latitude ?? 0,
                                longitude: stationModel?.longitude ?? 0,
                              );
                            },
                            splashColor: AppColors.white.withValues(alpha: 0.3),
                            highlightColor: AppColors.black.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(18),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    appContext.localText.location_trak,
                                    style: AppStyles.getBold(
                                      context: context,
                                      fontSize: AppSize.s16,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  const Gap(AppSize.s8),
                                  SvgPicture.asset(
                                    AppAssets.trackLocation,
                                    height: AppSize.s24,
                                    width: AppSize.s24,
                                    colorFilter: ColorFilter.mode(
                                      AppColors.white,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
