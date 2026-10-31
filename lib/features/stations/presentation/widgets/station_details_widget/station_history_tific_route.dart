import 'package:flutter/material.dart';
import 'package:fuelsense/core/application/resource/app_colors.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:fuelsense/features/stations/domain/entities/station_entity.dart';
import 'package:fuelsense/features/stations/domain/extensions/station_extensions.dart';
import 'package:gap/gap.dart';

class StationHistoryTificRoute extends StatelessWidget {
  const StationHistoryTificRoute({
    super.key,
    required this.appContext,
    required this.stationEntity,
  });

  final AppContext appContext;
  final StationEntity stationEntity;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppPadding.p20,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p12,
        vertical: AppPadding.p8,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF9F6),
        borderRadius: BorderRadius.circular(AppSize.s14),
        border: Border.all(
          width: 1,
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  appContext.localText.route_nigber_station,
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  style: AppStyles.getBold(
                    context: context,
                    color: const Color(0xFF4A5957),
                    fontSize: AppSize.s12,
                  ),
                ),
                const Gap(AppSize.s5),
                Expanded(
                  child: Text(
                    stationEntity.trafficStatus.arabicShortLabel,
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    style: AppStyles.getBold(
                      context: context,
                      color: const Color(0xFF4A5957),
                      fontSize: AppSize.s12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Gap(AppSize.s10),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.p8,
              vertical: AppPadding.p2,
            ),
            decoration: ShapeDecoration(
              color: const Color(0xFFFCF4DC),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.s10),
              ),
            ),
            child: Column(
              children: [
                Text(
                  '+%${stationEntity.trafficDelayRatio}',
                  style: AppStyles.getExtraBold(
                    context: context,
                    color: const Color(0xFF11201F),
                    fontSize: AppSize.s15,
                  ),
                ),
                Text(
                  appContext.localText.letency,
                  style: AppStyles.getMeduim(
                    context: context,
                    color: const Color(0xFF4A5957),
                    fontSize: AppSize.s12,
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
