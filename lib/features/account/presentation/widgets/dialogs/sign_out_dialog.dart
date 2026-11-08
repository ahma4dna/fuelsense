import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';

class SignOutDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const SignOutDialog({
    super.key,
    required this.onConfirm,
  });

  static Future<void> show({
    required BuildContext context,
    required VoidCallback onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (dialogContext) => SignOutDialog(onConfirm: onConfirm),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appContext = AppContext.of(context);

    return Directionality(
      textDirection: appContext.isRt ? TextDirection.rtl : TextDirection.ltr,
      child: AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s22),
        ),
        title: Row(
          children: [
            const Icon(
              Icons.logout_rounded,
              color: Color(0xFFD92D20),
              size: AppSize.s24,
            ),
            const Gap(AppSize.s10),
            Text(
              appContext.localText.logout_title,
              style: AppStyles.getExtraBold(
                context: context,
                fontSize: AppSize.s18,
                color: const Color(0xFF11201F),
              ),
            ),
          ],
        ),
        content: Text(
          appContext.localText.logout_confirm_desc,
          style: AppStyles.getMeduim(
            context: context,
            fontSize: AppSize.s14_5,
            color: const Color(0xFF5A6866),
          ).copyWith(height: AppSize.s1_5),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(
          AppPadding.p16,
          AppSize.s0,
          AppPadding.p16,
          AppPadding.p16,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              appContext.localText.cancel,
              style: AppStyles.getBold(
                context: context,
                fontSize: AppSize.s14,
                color: const Color(0xFF5A6866),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD92D20),
              foregroundColor: Colors.white,
              elevation: AppSize.s0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.s12),
              ),
            ),
            child: Text(
              appContext.localText.confirm_logout,
              style: AppStyles.getBold(
                context: context,
                fontSize: AppSize.s14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
