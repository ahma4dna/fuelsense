import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fuelsense/core/application/resource/app_assets.dart';
import 'package:fuelsense/core/application/resource/app_colors.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/features/home/data/models/station_model.dart';
import 'package:gap/gap.dart';

class MyLocationAndTogleStyleMap extends StatelessWidget {
  final void Function() toggleMapType;
  final Future<void> Function() selectMyLoction;
  final StationModel? selectedStation;
  final double stationWidgetHeight;
  final bool isGettingLocation;
  const MyLocationAndTogleStyleMap({
    super.key,
    required this.toggleMapType,
    this.selectedStation,
    required this.stationWidgetHeight,
    required this.selectMyLoction,
    required this.isGettingLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: AppSize.s16,
      bottom: AppSize.s16,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        padding: EdgeInsets.only(
          bottom: selectedStation != null
              ? MediaQuery.paddingOf(context).bottom + stationWidgetHeight
              : MediaQuery.paddingOf(context).bottom + AppSize.s120,
        ),
        child: Column(
          children: [
            InkWell(
              onTap: isGettingLocation
                  ? null
                  : () async {
                      await selectMyLoction.call();
                    },
              child: Container(
                height: AppSize.s48,
                width: AppSize.s48,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    AppAssets.myLocation,
                    height: AppSize.s28,
                    width: AppSize.s28,
                  ),
                ),
              ),
            ),
            const Gap(AppSize.s16),
            InkWell(
              onTap: () {
                toggleMapType.call();
              },
              child: Container(
                height: AppSize.s48,
                width: AppSize.s48,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    AppAssets.stalite,
                    height: AppSize.s28,
                    width: AppSize.s28,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
