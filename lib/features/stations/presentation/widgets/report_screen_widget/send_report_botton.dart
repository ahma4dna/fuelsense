import 'package:flutter/material.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';

class SendReportBotton extends StatelessWidget {
  const new({
    super.key,
    required this.onPressed,
    required this.appContext,
  });

  final void Function() onPressed;
  final AppContext appContext;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.s56,
      child: Container(
        height: AppSize.s56,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0xCC00BFA6),
              blurRadius: 24,
              offset: Offset(0, 10),
              spreadRadius: -10,
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00BFA6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            appContext.localText.send_report,
            style: AppStyles.getBold(
              context: context,
              color: const Color(0xFF0F172A),
              fontSize: AppSize.s16,
            ),
          ),
        ),
      ),
    );
  }
}
