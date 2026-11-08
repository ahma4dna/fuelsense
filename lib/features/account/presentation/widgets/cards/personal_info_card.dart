import 'package:flutter/material.dart';
import 'package:fuelsense/features/account/domain/entities/account_profile_entity.dart';
import 'package:gap/gap.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';

class PersonalInfoCard extends StatelessWidget {
  final AccountProfileEntity profile;
  final VoidCallback onEditTap;

  const PersonalInfoCard({
    super.key,
    required this.profile,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    final appContext = AppContext.of(context);

    return Container(
      padding: const EdgeInsets.all(AppPadding.p16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSize.s20),
        border: Border.all(
          color: const Color(0xFFE6E2D9),
          width: AppSize.s1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: AppSize.s36,
                height: AppSize.s36,
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F4EE),
                  borderRadius: BorderRadius.circular(AppSize.s10),
                ),
                child: const Icon(
                  Icons.badge_outlined,
                  size: AppSize.s19,
                  color: Color(0xFF0F6E67),
                ),
              ),
              const Gap(AppSize.s12),
              Text(
                appContext.localText.full_name,
                style: AppStyles.getMeduim(
                  context: context,
                  fontSize: AppSize.s13_5,
                  color: const Color(0xFF5A6866),
                ),
              ),
              const Spacer(),
              Flexible(
                child: Text(
                  profile.fullName,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.getExtraBold(
                    context: context,
                    fontSize: AppSize.s14,
                    color: const Color(0xFF11201F),
                  ),
                ),
              ),
            ],
          ),
          const Divider(
            height: AppSize.s22,
            color: Color(0xFFECE9E0),
          ),
        ],
      ),
    );
  }
}
