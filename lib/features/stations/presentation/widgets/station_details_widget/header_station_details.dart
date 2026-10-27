import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fuelsense/core/application/resource/app_assets.dart';
import 'package:fuelsense/core/application/resource/app_colors.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class HeaderStationDetails extends StatelessWidget {
  const new({
    super.key,
    required this.appContext,
  });

  final AppContext appContext;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppSize.s44,
          height: AppSize.s44,
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
            border: Border.all(
              width: 1,
              color: AppColors.border,
            ),
          ),
          child: GestureDetector(
            onTap: () {
              context.pop();
            },
            child: Center(
              child: SvgPicture.asset(
                AppAssets.back,
                width: AppSize.s22,
                height: AppSize.s22,
              ),
            ),
          ),
        ),
        const Gap(AppSize.s12),
        Text(
          appContext.localText.station_details,
          style: AppStyles.getBold(
            color: const Color(0xFF0F172A),
            fontSize: AppSize.s18,
            context: context,
          ),
        ),
      ],
    );
  }
}
