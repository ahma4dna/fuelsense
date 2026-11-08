import 'package:flutter/material.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:gap/gap.dart';

import '../../../domain/entities/account_profile_entity.dart';

class AccountHeaderSection extends StatelessWidget {
  final AccountProfileEntity profile;
  final VoidCallback onEditTap;

  const AccountHeaderSection({
    super.key,
    required this.profile,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    final appContext = AppContext.of(context);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF07332C),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppSize.s30),
          bottomRight: Radius.circular(AppSize.s30),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppPadding.p16,
            AppPadding.p12,
            AppPadding.p16,
            AppPadding.p20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appContext.localText.account_and_settings,
                style: AppStyles.getExtraBold(
                  context: context,
                  fontSize: AppSize.s26,
                  color: Colors.white,
                ),
              ),
              const Gap(AppSize.s16),
              Container(
                padding: const EdgeInsets.all(AppPadding.p16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A3D35),
                  borderRadius: BorderRadius.circular(AppSize.s20),
                  border: Border.all(
                    color: const Color(0xFF1A574E),
                    width: AppSize.s1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: AppSize.s56,
                      height: AppSize.s56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F6E67),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF53C0B2),
                          width: AppSize.s1_5,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        profile.initials,
                        style: AppStyles.getExtraBold(
                          context: context,
                          fontSize: AppSize.s20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Gap(AppSize.s14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.fullName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppStyles.getExtraBold(
                              context: context,
                              fontSize: AppSize.s17,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: onEditTap,
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFF0E453D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSize.s14),
                        ),
                      ),
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: Color(0xFFD6E6E3),
                        size: AppSize.s20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
