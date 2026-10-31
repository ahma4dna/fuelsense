import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fuelsense/core/application/resource/app_assets.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:gap/gap.dart';

class HintTodayReportWidget extends StatelessWidget {
  const HintTodayReportWidget({
    super.key,
    required this.appContext,
  });

  final AppContext appContext;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p14,
        vertical: AppPadding.p12,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: AppPadding.p20,
      ),
      decoration: ShapeDecoration(
        color: const Color(0xFFEEF9F7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            AppAssets.note,
            height: AppSize.s18,
            width: AppSize.s18,
          ),
          const Gap(AppSize.s8),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                appContext.localText.reports_today_uers_hint,
                maxLines: 2,
                style: AppStyles.getMeduim(
                  context: context,
                  color: const Color(0xFF083A38),
                  fontSize: AppSize.s14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
