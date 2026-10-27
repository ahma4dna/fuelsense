import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fuelsense/core/application/resource/app_assets.dart';
import 'package:fuelsense/core/application/resource/app_colors.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:fuelsense/features/stations/domain/entities/station_entity.dart';
import 'package:gap/gap.dart';

class SearchStaionWidget extends StatelessWidget {
  final StationEntity stationModel;
  final VoidCallback? onTap;
  final String query;
  const SearchStaionWidget({
    super.key,
    required this.stationModel,
    this.onTap,
    this.query = '',
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.primary.withValues(alpha: 0.12),
      highlightColor: AppColors.primary.withValues(alpha: 0.06),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.p16,
          vertical: AppPadding.p10,
        ),
        child: Row(
          children: [
            Container(
              width: AppSize.s44,
              height: AppSize.s44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppAssets.staions,
                  width: AppSize.s24,
                  height: AppSize.s24,
                ),
              ),
            ),
            const Gap(12),
            Expanded(child: _buildName(context)),
            const Gap(AppSize.s10),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.1),
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppAssets.myLocation,
                  width: 18,
                  height: 18,
                  colorFilter: ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildName(BuildContext context) {
    final baseStyle = AppStyles.getRgular(
      context: context,
      fontSize: AppSize.s16,
    );

    final name = stationModel.name;
    final q = query.trim();

    Widget plain() => Text(
      name,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: baseStyle,
    );

    if (q.isEmpty) return plain();

    final lowerName = name.toLowerCase();
    if (lowerName.length != name.length) return plain();

    final start = lowerName.indexOf(q.toLowerCase());
    if (start < 0) return plain();
    final end = start + q.length;

    return Text.rich(
      TextSpan(
        style: baseStyle,
        children: [
          TextSpan(text: name.substring(0, start)),
          TextSpan(
            text: name.substring(start, end),
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextSpan(text: name.substring(end)),
        ],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
