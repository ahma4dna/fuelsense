import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';

import 'about_app_hero_card.dart';
import 'about_feature_tile.dart';

class AboutAppBottomSheet extends StatelessWidget {
  const AboutAppBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final appContext = AppContext.of(context);

    final features = [
      (
        icon: Icons.radar_rounded,
        title: appContext.localText.about_feature_radar_title,
        subtitle: appContext.localText.about_feature_radar_subtitle,
      ),
      (
        icon: Icons.route_rounded,
        title: appContext.localText.about_feature_traffic_title,
        subtitle: appContext.localText.about_feature_traffic_subtitle,
      ),
      (
        icon: Icons.auto_awesome_rounded,
        title: appContext.localText.about_feature_ai_title,
        subtitle: appContext.localText.about_feature_ai_subtitle,
      ),
    ];

    return Directionality(
      textDirection: appContext.isRt ? TextDirection.rtl : TextDirection.ltr,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppPadding.p23,
          AppPadding.p16,
          AppPadding.p23,
          AppPadding.p28,
        ),
        decoration: const BoxDecoration(
          color: Color(0xFFF6F4EE),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSize.s28),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: AppSize.s44,
                  height: AppSize.s4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD0CCC2),
                    borderRadius: BorderRadius.circular(AppSize.s10),
                  ),
                ),
              ),
              const Gap(AppSize.s20),
              const AboutAppHeroCard(),
              const Gap(AppSize.s18),
              ...features.map(
                (item) => AboutFeatureTile(
                  icon: item.icon,
                  title: item.title,
                  subtitle: item.subtitle,
                ),
              ),
              const Gap(AppSize.s10),
              SizedBox(
                height: AppSize.s48,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F6E67),
                    foregroundColor: Colors.white,
                    elevation: AppSize.s0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSize.s14),
                    ),
                  ),
                  child: Text(
                    appContext.localText.close,
                    style: AppStyles.getBold(
                      context: context,
                      fontSize: AppSize.s15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
