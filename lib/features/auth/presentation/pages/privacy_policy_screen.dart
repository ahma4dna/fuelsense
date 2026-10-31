import 'package:flutter/material.dart';
import 'package:fuelsense/core/application/resource/app_colors.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appContext = AppContext.of(context);
    final localText = appContext.localText;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: AppSize.s28,
            color: const Color(0xFF11201F),
          ),
        ),
        title: Text(
          localText.privacy_policy,
          style: AppStyles.getExtraBold(
            context: context,
            fontSize: AppSize.s18,
            color: const Color(0xFF11201F),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            AppSize.s20,
            AppSize.s8,
            AppSize.s20,
            AppSize.s28,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Card
              Container(
                padding: EdgeInsets.all(AppSize.s20),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A3832),
                  borderRadius: BorderRadius.circular(AppSize.s20),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.verified_user_outlined,
                      color: const Color(0xFF4DB6AC),
                      size: AppSize.s34,
                    ),
                    Gap(AppSize.s14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localText.privacy_header_title,
                            style: AppStyles.getExtraBold(
                              context: context,

                              fontSize: AppSize.s16,
                              color: AppColors.white,
                            ),
                          ),
                          Gap(AppSize.s4),
                          Text(
                            localText.privacy_header_subtitle,
                            style: AppStyles.getMeduim(
                              context: context,

                              fontSize: AppSize.s12,
                              color: const Color(0xFFAEC7C3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Gap(AppSize.s18),

              _PrivacyItemCard(
                icon: Icons.person_outline_rounded,
                title: localText.privacy_section_1_title,
                description: localText.privacy_section_1_description,
              ),

              _PrivacyItemCard(
                icon: Icons.location_on_outlined,
                title: localText.privacy_section_2_title,
                description: localText.privacy_section_2_description,
              ),

              _PrivacyItemCard(
                icon: Icons.public_rounded,
                title: localText.privacy_section_3_title,
                description: localText.privacy_section_3_description,
              ),

              _PrivacyItemCard(
                icon: Icons.notifications_active_outlined,
                title: localText.privacy_section_4_title,
                description: localText.privacy_section_4_description,
              ),

              _PrivacyItemCard(
                icon: Icons.lock_outline_rounded,
                title: localText.privacy_section_5_title,
                description: localText.privacy_section_5_description,
              ),

              Gap(AppSize.s10),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrivacyItemCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _PrivacyItemCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSize.s14),
      padding: EdgeInsets.all(AppSize.s18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSize.s18),
        border: Border.all(
          color: const Color(0xFFE6E2D9),
          width: AppSize.s1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: AppSize.s34,
                height: AppSize.s34,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF9F7),
                  borderRadius: BorderRadius.circular(AppSize.s10),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF0F6E67),
                  size: AppSize.s20,
                ),
              ),
              Gap(AppSize.s10),
              Expanded(
                child: Text(
                  title,
                  style: AppStyles.getExtraBold(
                    context: context,
                    fontSize: AppSize.s15,
                    color: const Color(0xFF11201F),
                  ),
                ),
              ),
            ],
          ),
          Gap(AppSize.s10),
          Text(
            description,
            style: AppStyles.getMeduim(
              context: context,

              fontSize: AppSize.s14,
              color: const Color(0xFF4A5957),
            ).copyWith(height: 1.65),
          ),
        ],
      ),
    );
  }
}
