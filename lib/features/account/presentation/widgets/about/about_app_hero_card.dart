import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';

class AboutAppHeroCard extends StatelessWidget {
  const AboutAppHeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    final appContext = AppContext.of(context);

    return Container(
      padding: const EdgeInsets.all(AppPadding.p20),
      decoration: BoxDecoration(
        color: const Color(0xFF07332C),
        borderRadius: BorderRadius.circular(AppSize.s22),
      ),
      child: Column(
        children: [
          Container(
            width: AppSize.s65,
            height: AppSize.s65,
            decoration: BoxDecoration(
              color: const Color(0xFF0E453D),
              borderRadius: BorderRadius.circular(AppSize.s18),
              border: Border.all(
                color: const Color(0xFF22695E),
                width: AppSize.s1,
              ),
            ),
            child: const Icon(
              Icons.local_gas_station_rounded,
              color: Color(0xFF53C0B2),
              size: AppSize.s34,
            ),
          ),
          const Gap(AppSize.s12),
          Text(
            appContext.localText.about_hero_title,
            style: AppStyles.getExtraBold(
              context: context,
              fontSize: AppSize.s20,
              color: Colors.white,
            ),
          ),
          const Gap(AppSize.s6),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.p12,
              vertical: AppPadding.p4,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF0E453D),
              borderRadius: BorderRadius.circular(AppSize.s20),
            ),
            child: Text(
              appContext.localText.about_version_label,
              style: AppStyles.getBold(
                context: context,
                fontSize: AppSize.s12,
                color: const Color(0xFF8ABDB5),
              ),
            ),
          ),
          const Gap(AppSize.s12),
          Text(
            appContext.localText.about_app_description,
            textAlign: TextAlign.center,
            style: AppStyles.getMeduim(
              context: context,
              fontSize: AppSize.s13_5,
              color: const Color(0xFFD6E6E3),
            ).copyWith(height: AppSize.s1_5),
          ),
        ],
      ),
    );
  }
}
