import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fuelsense/core/application/resource/app_assets.dart';
import 'package:fuelsense/core/application/resource/app_colors.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:fuelsense/core/utils/location_service.dart';
import 'package:gap/gap.dart';

import '../../../domain/entities/station_directory_entity.dart';
import 'card_mini_icon_box.dart';
import 'traffic_three_bars_indicator.dart';

class StationDirectoryCard extends StatelessWidget {
  final StationDirectoryEntity station;
  final VoidCallback? onTap;

  const StationDirectoryCard({
    super.key,
    required this.station,
    this.onTap,
  });

  ({Color borderColor, Color pillBg, Color pillText, Color dotColor}) _resolveStatusColors() {
    switch (station.status) {
      case 'open':
        return (
          borderColor: const Color(0xFF22C55E),
          pillBg: const Color(0xFFE6F8ED),
          pillText: const Color(0xFF0F7A38),
          dotColor: const Color(0xFF16A34A),
        );
      case 'refilling':
        return (
          borderColor: const Color(0xFFF59E0B),
          pillBg: const Color(0xFFFEF3DC),
          pillText: const Color(0xFFB45309),
          dotColor: const Color(0xFFD97706),
        );
      case 'on_the_way':
        return (
          borderColor: const Color(0xFF3B82F6),
          pillBg: const Color(0xFFEFF6FF),
          pillText: const Color(0xFF1D4ED8),
          dotColor: const Color(0xFF2563EB),
        );
      default:
        return (
          borderColor: const Color(0xFF94A3B8),
          pillBg: const Color(0xFFF1F5F9),
          pillText: const Color(0xFF475569),
          dotColor: const Color(0xFF64748B),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = _resolveStatusColors();
    final appContext = AppContext.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSize.s22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: AppSize.s0_02),
              blurRadius: AppSize.s10,
              offset: const Offset(AppSize.s0, AppSize.s4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSize.s22),
          child: Container(
            decoration: BoxDecoration(
              border: BorderDirectional(
                start: BorderSide(
                  color: palette.borderColor,
                  width: AppSize.s5,
                ),
              ),
            ),
            padding: const EdgeInsets.all(AppPadding.p16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            station.name,
                            style: AppStyles.getExtraBold(
                              context: context,
                              fontSize: AppSize.s18,
                              color: const Color(0xFF11201F),
                            ),
                          ),
                          const Gap(AppSize.s2),
                          Text(
                            '(${station.city})',
                            style: AppStyles.getMeduim(
                              context: context,
                              fontSize: AppSize.s13_5,
                              color: const Color(0xFF8C9896),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          border: Border.all(
                            width: 1,
                            color: AppColors.border,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: InkWell(
                          onTap: () async {
                            await LocationService.openMap(
                              latitude: station.latitude,
                              longitude: station.longitude,
                            );
                          },
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Center(
                              child: SvgPicture.asset(
                                AppAssets.trackLocation,
                                colorFilter: const ColorFilter.mode(
                                  Color(0XFF083A38),
                                  BlendMode.srcIn,
                                ),
                                width: AppSize.s19,
                                height: AppSize.s19,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(AppSize.s14),
                Row(
                  children: [
                    const CardMiniIconBox(
                      icon: Icons.local_gas_station_outlined,
                    ),
                    const Gap(AppSize.s10),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppPadding.p12,
                          vertical: AppPadding.p6,
                        ),
                        decoration: BoxDecoration(
                          color: palette.pillBg,
                          borderRadius: BorderRadius.circular(AppSize.s20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: AppSize.s8,
                              height: AppSize.s8,
                              decoration: BoxDecoration(
                                color: palette.dotColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const Gap(AppSize.s7),
                            Flexible(
                              child: Text(
                                station.statusBadgeText,
                                style: AppStyles.getBold(
                                  context: context,
                                  fontSize: AppSize.s13,
                                  color: palette.pillText,
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
                Row(
                  children: [
                    const CardMiniIconBox(
                      icon: Icons.route_outlined,
                    ),
                    const Gap(AppSize.s10),
                    TrafficThreeBarsIndicator(
                      severityLevel: station.trafficSeverityLevel,
                    ),
                    const Gap(AppSize.s8),
                    Expanded(
                      child: Text(
                        station.trafficStatusText,
                        style: AppStyles.getMeduim(
                          context: context,
                          fontSize: AppSize.s13_5,
                          color: const Color(0xFF2B3A38),
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(AppSize.s10),
                Row(
                  children: [
                    const CardMiniIconBox(
                      icon: Icons.chat_bubble_outline_rounded,
                    ),
                    const Gap(AppSize.s10),
                    Expanded(
                      child: Text(
                        '${station.todayReportsCount} ${appContext.localText.today_opinions} (${station.queueLabelText})',
                        style: AppStyles.getMeduim(
                          context: context,
                          fontSize: AppSize.s13_5,
                          color: const Color(0xFF374543),
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
    );
  }
}
