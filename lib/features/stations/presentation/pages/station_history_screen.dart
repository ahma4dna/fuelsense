import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fuelsense/core/application/resource/app_assets.dart';
import 'package:fuelsense/core/application/resource/app_colors.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:fuelsense/features/stations/domain/entities/station_entity.dart';
import 'package:fuelsense/features/stations/domain/extensions/station_extensions.dart';
import 'package:gap/gap.dart';

class StationHistoryScreen extends StatelessWidget {
  final StationEntity stationEntity;
  const StationHistoryScreen({super.key, required this.stationEntity});

  @override
  Widget build(BuildContext context) {
    final appContext = AppContext.of(context);

    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: HeaderSationHistory(
              stationEntity: stationEntity,
            ),
          ),
          const Gap(AppSize.s12),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.p20,
            ),
            child: StationHistoryStateWidget(
              appContext: appContext,
              stationEntity: stationEntity,
            ),
          ),
          const Gap(AppSize.s12),
          StationHistoryTificRoute(
            appContext: appContext,
            stationEntity: stationEntity,
          ),
          const Gap(AppSize.s16),
          Container(
            height: AppSize.s52,
            padding: const EdgeInsets.all(4),
            margin: const EdgeInsets.symmetric(
              horizontal: AppPadding.p20,
            ),
            decoration: ShapeDecoration(
              color: const Color(0x99E6E1D8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StationHistoryTificRoute extends StatelessWidget {
  const new({
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
                  '+%${stationEntity.trafficDelayRatio ?? 0}',
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
                    color: Color(0xFF4A5957),
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

class StationHistoryStateWidget extends StatelessWidget {
  const new({
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
          height: 100,
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
                        Text(
                          getOfficialStatusDetails(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.getBold(
                            context: context,
                            color: const Color(0xFF11201F),
                            fontSize: AppSize.s14,
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
                              stationEntity.lastUpdatedRelativeText ?? '',
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

class HeaderSationHistory extends StatelessWidget {
  const new({
    super.key,
    required this.stationEntity,
  });

  final StationEntity stationEntity;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppSize.s50,
          height: AppSize.s50,
          margin: const EdgeInsets.only(right: AppPadding.p20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.white,
            border: Border.all(width: 1, color: AppColors.border),
          ),
          child: Center(
            child: Icon(
              Icons.arrow_back_ios_new,
              size: AppSize.s25,
            ),
          ),
        ),
        const Gap(AppSize.s5),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stationEntity.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.getExtraBold(
                  context: context,
                  color: const Color(0xFF4A5957),
                  fontSize: AppSize.s20,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: AppSize.s50,
          height: AppSize.s50,
          margin: const EdgeInsets.only(left: AppPadding.p20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
          ),
          child: Center(
            child: Icon(
              Icons.star,
              color: AppColors.white,
              size: AppSize.s25,
            ),
          ),
        ),
      ],
    );
  }
}
