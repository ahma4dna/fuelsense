import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fuelsense/core/application/resource/app_assets.dart';
import 'package:fuelsense/core/application/resource/app_colors.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:fuelsense/core/utils/location_service.dart';
import 'package:fuelsense/features/home/data/models/station_model.dart';
import 'package:fuelsense/features/home/presentation/routes/home_path.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class StationWidget extends StatelessWidget {
  final StationModel? selectedStation;
  final void Function()? closeStaion;
  final AppContext appContext;
  const StationWidget({super.key, this.selectedStation, this.closeStaion, required this.appContext});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: AppSize.s16,
      right: AppSize.s16,
      bottom: AppSize.s16,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 500),
        curve: selectedStation != null ? Curves.easeOutBack : Curves.easeInCubic,
        offset: selectedStation != null ? Offset.zero : const Offset(0, 1.2),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 500),
          curve: selectedStation != null ? Curves.easeOutBack : Curves.easeInCubic,
          scale: selectedStation != null ? 1.0 : 0.8,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: selectedStation != null ? 1.0 : 0.0,
            child: IgnorePointer(
              ignoring: selectedStation == null,
              child: Container(
                margin: EdgeInsets.only(
                  bottom: MediaQuery.paddingOf(context).bottom + 105,
                ),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: closeStaion,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF3F4F6),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              size: 20,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: ShapeDecoration(
                            color: selectedStation?.statusLabelColor.withValues(alpha: 0.1),
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
                                  color: selectedStation?.statusLabelColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(AppSize.s100),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                selectedStation?.statusLabel ?? "",
                                style: AppStyles.getBold(
                                  color: selectedStation?.statusLabelColor,
                                  fontSize: AppSize.s14,
                                  context: context,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Gap(AppSize.s22),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: AlignmentGeometry.center,
                          children: [
                            SizedBox(
                              width: AppSize.s65,
                              height: AppSize.s65,
                              child: CircularProgressIndicator(
                                strokeWidth: 8,
                                value: selectedStation?.currentProbability ?? 0,
                                color: selectedStation?.statusLabelColor,
                                backgroundColor: const Color(0XFFE2E7F1),
                                strokeCap: StrokeCap.round,
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: ((selectedStation?.currentProbability ?? 0) * 100).toStringAsFixed(0),
                                style: AppStyles.getExtraBold(
                                  context: context,
                                  color: const Color(0xFF0F172A),
                                  fontSize: AppSize.s20,
                                ),
                                children: [
                                  TextSpan(
                                    text: '%',
                                    style: TextStyle(
                                      fontSize: AppSize.s16,
                                      color: const Color(0xFF0F172A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Gap(AppSize.s20),
                        Expanded(
                          child: Text(
                            selectedStation?.name ?? 'محطة وقود',
                            style: AppStyles.getBold(
                              color: const Color(0xFF0F172A),
                              fontSize: AppSize.s20,
                              context: context,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const Gap(AppSize.s24),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: AppSize.s48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
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
                                borderRadius: BorderRadius.circular(18),
                                onTap: () {
                                  context.pushNamed(
                                    stationDetailsName,
                                    extra: (selectedStation),
                                  );
                                },
                                child: Center(
                                  child: Text(
                                    appContext.localText.view_detail_st,
                                    style: AppStyles.getBold(
                                      context: context,
                                      fontSize: AppSize.s16,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Gap(AppSize.s16),
                        Material(
                          color:
                              selectedStation?.statusLabelColor.withValues(alpha: AppSize.s0_2) ??
                              AppColors.primary.withValues(alpha: AppSize.s0_2),
                          borderRadius: BorderRadius.circular(AppSize.s18),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(AppSize.s18),
                            onTap: () async {
                              await LocationService.openMap(
                                latitude: selectedStation?.latitude ?? 0,
                                longitude: selectedStation?.longitude ?? 0,
                              );
                            },
                            child: SizedBox(
                              width: AppSize.s48,
                              height: AppSize.s48,
                              child: Center(
                                child: SvgPicture.asset(
                                  AppAssets.trackLocation,
                                  height: AppSize.s24,
                                  width: AppSize.s24,
                                  colorFilter: ColorFilter.mode(
                                    selectedStation?.statusLabelColor ?? AppColors.primary,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
