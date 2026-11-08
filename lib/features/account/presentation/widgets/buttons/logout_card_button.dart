import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';

class LogoutCardButton extends StatelessWidget {
  final bool isLoggingOut;
  final VoidCallback onTap;

  const LogoutCardButton({
    super.key,
    required this.isLoggingOut,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appContext = AppContext.of(context);

    return InkWell(
      onTap: isLoggingOut ? null : onTap,
      borderRadius: BorderRadius.circular(AppSize.s18),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p16,
          vertical: AppPadding.p16,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(AppSize.s18),
          border: Border.all(
            color: const Color(0xFFFECACA),
            width: AppSize.s1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoggingOut)
              const SizedBox(
                width: AppSize.s20,
                height: AppSize.s20,
                child: CircularProgressIndicator(
                  strokeWidth: AppSize.s2,
                  color: Color(0xFFD92D20),
                ),
              )
            else
              const Icon(
                Icons.logout_rounded,
                color: Color(0xFFD92D20),
                size: AppSize.s20,
              ),
            const Gap(AppSize.s10),
            Text(
              isLoggingOut ? appContext.localText.logging_out : appContext.localText.logout_button_label,
              style: AppStyles.getExtraBold(
                context: context,
                fontSize: AppSize.s15,
                color: const Color(0xFFB91C1C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
