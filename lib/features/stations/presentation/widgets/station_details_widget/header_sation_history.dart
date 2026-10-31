import 'package:flutter/material.dart';
import 'package:fuelsense/core/application/resource/app_colors.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:fuelsense/features/stations/domain/entities/station_entity.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class HeaderSationHistory extends StatelessWidget {
  const HeaderSationHistory({
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
            child: InkWell(
              onTap: () {
                context.pop();
              },
              child: Icon(
                Icons.arrow_back_ios_new,
                size: AppSize.s25,
              ),
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
