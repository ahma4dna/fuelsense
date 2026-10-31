import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fuelsense/core/application/resource/app_assets.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:fuelsense/features/stations/domain/entities/station_entity.dart';
import 'package:fuelsense/features/stations/domain/extensions/station_extensions.dart';
import 'package:gap/gap.dart';

class StationHistoryStateWidget extends StatelessWidget {
  const StationHistoryStateWidget({
    super.key,
    required this.appContext,
    required this.stationEntity,
  });

  final AppContext appContext;
  final StationEntity stationEntity;

  @override
  Widget build(BuildContext context) {
    String getOfficialStatusDetails() {
      if (stationEntity.statusNotes != null && stationEntity.statusNotes!.trim().isNotEmpty) {
        return stationEntity.statusNotes!;
      }
      final amount = (stationEntity.lastFuelAmount != null && stationEntity.lastFuelAmount!.trim().isNotEmpty)
          ? ' (${stationEntity.lastFuelAmount})'
          : '';
      return '${stationEntity.status.arabicLabel}$amount';
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            color: const Color(0xFFF08A00),
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 10,
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFFF6E5),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                bottomLeft: Radius.circular(14),
                topRight: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                left: AppPadding.p12,
                bottom: AppPadding.p10,
                top: AppPadding.p10,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(AppSize.s16),
                  SvgPicture.asset(
                    width: AppSize.s45,
                    height: AppSize.s45,
                    AppAssets.stateStaion,
                    fit: BoxFit.cover,
                  ),
                  const Gap(AppSize.s12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appContext.localText.station_statee,
                          style: AppStyles.getBold(
                            context: context,
                            color: const Color(0xFFB54708),
                            fontSize: AppSize.s16,
                          ),
                        ),
                        const Gap(AppSize.s5),
                        Expanded(
                          child: Text(
                            getOfficialStatusDetails(),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: AppStyles.getBold(
                              context: context,
                              color: const Color(0xFF11201F),
                              fontSize: AppSize.s14,
                            ),
                          ),
                        ),
                        const Gap(AppSize.s5),
                        Row(
                          children: [
                            SvgPicture.asset(
                              width: AppSize.s16,
                              height: AppSize.s16,
                              AppAssets.clock,
                              fit: BoxFit.cover,
                            ),
                            const Gap(AppSize.s5),
                            Text(
                              stationEntity.lastUpdatedRelativeText,
                              textAlign: TextAlign.right,
                              style: AppStyles.getMeduim(
                                context: context,
                                color: const Color(0xFF4A5957),
                                fontSize: AppSize.s14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
