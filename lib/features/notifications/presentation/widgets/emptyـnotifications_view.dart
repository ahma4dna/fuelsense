import 'package:flutter/material.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:fuelsense/core/widget/smooth_animations.dart';
import 'package:gap/gap.dart';

class EmptyNotificationsView extends StatelessWidget {
  const EmptyNotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final appContext = AppContext.of(context);

    return ListView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: const EdgeInsets.all(AppPadding.p32),
      children: [
        const Gap(AppSize.s60),
        const EmptyNotificationsIconBadge(),
        const Gap(AppSize.s18),
        FadeSlide(
          delay: const Duration(milliseconds: 150),
          dy: AppSize.s12,
          child: Text(
            appContext.localText.empty_notifications_title,
            textAlign: TextAlign.center,
            style: AppStyles.getExtraBold(
              context: context,
              fontSize: AppSize.s18,
              color: const Color(0xFF11201F),
            ),
          ),
        ),
        const Gap(AppSize.s8),
        FadeSlide(
          delay: const Duration(milliseconds: 280),
          dy: AppSize.s12,
          child: Text(
            appContext.localText.empty_notifications_subtitle,
            textAlign: TextAlign.center,
            style: AppStyles.getMeduim(
              context: context,
              fontSize: AppSize.s14,
              color: const Color(0xFF5A6866),
            ).copyWith(height: AppSize.s1_5),
          ),
        ),
      ],
    );
  }
}

class EmptyNotificationsIconBadge extends StatelessWidget {
  const EmptyNotificationsIconBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeSlide(
      dy: AppSize.s12,
      scaleFrom: AppSize.s0_6,
      curve: Curves.easeOutBack,
      duration: const Duration(milliseconds: 650),
      child: Center(
        child: Container(
          width: AppSize.s80,
          height: AppSize.s80,
          decoration: const BoxDecoration(
            color: Color(0xFFEEF9F7),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.notifications_none_rounded,
            size: AppSize.s40,
            color: Color(0xFF0F6E67),
          ),
        ),
      ),
    );
  }
}
