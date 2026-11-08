import 'package:flutter/material.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:gap/gap.dart';

class EditProfileHeader extends StatelessWidget {
  const EditProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final appContext = AppContext.of(context);

    return Row(
      children: [
        Container(
          width: AppSize.s40,
          height: AppSize.s40,
          decoration: BoxDecoration(
            color: const Color(0xFFEEF9F7),
            borderRadius: BorderRadius.circular(AppSize.s12),
          ),
          child: const Icon(
            Icons.manage_accounts_rounded,
            color: Color(0xFF0F6E67),
            size: AppSize.s22,
          ),
        ),
        const Gap(AppSize.s12),
        Expanded(
          child: Text(
            appContext.localText.edit_profile_title,
            style: AppStyles.getExtraBold(
              context: context,
              fontSize: AppSize.s18,
              color: const Color(0xFF11201F),
            ),
          ),
        ),
      ],
    );
  }
}
