import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fuelsense/core/application/resource/app_assets.dart';
import 'package:fuelsense/core/application/resource/app_colors.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:fuelsense/features/home/data/models/station_model.dart';
import 'package:gap/gap.dart';

class SearchStaionWidget extends StatelessWidget {
  final StationModel? stationModel;
  final void Function()? onTap;
  const SearchStaionWidget({
    super.key,
    required this.stationModel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: AppPadding.p10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.s18),
        boxShadow: [
          BoxShadow(
            color: Color(0x3F0F172A),
            blurRadius: 24,
            offset: Offset(0, 8),
            spreadRadius: -10,
          ),
          BoxShadow(
            color: Color(0xB2E1E8F0),
            blurRadius: 0,
            offset: Offset(0, 0),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSize.s18),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSize.s18),
          splashColor: AppColors.primary.withValues(alpha: 0.3),
          highlightColor: AppColors.primary.withValues(alpha: 0.1),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppPadding.p16,
              vertical: AppPadding.p10,
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  AppAssets.staions,
                  width: AppSize.s32,
                  height: AppSize.s32,
                ),
                const Gap(AppSize.s10),
                Expanded(
                  child: Text(
                    stationModel?.name ?? "شيل ",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.getRgular(
                      context: context,
                      fontSize: AppSize.s18,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.transparent,
                    borderRadius: BorderRadius.circular(AppSize.s18),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppSize.s18),
                    onTap: onTap,
                    child: SizedBox(
                      width: AppSize.s48,
                      height: AppSize.s48,
                      child: Center(
                        child: SvgPicture.asset(
                          AppAssets.myLocation,
                          height: AppSize.s24,
                          width: AppSize.s24,
                          colorFilter: ColorFilter.mode(
                            AppColors.black,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
