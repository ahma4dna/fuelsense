import 'package:flutter/material.dart';
import 'package:fuelsense/core/application/resource/app_colors.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';

class ContianCheckBotton extends StatelessWidget {
  const ContianCheckBotton({
    super.key,
    required this.onPressed,
    required this.title,
  });

  final String title;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.s56,
      child: Container(
        height: AppSize.s56,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0xB20F172A),
              blurRadius: 24,
              offset: Offset(0, 10),
              spreadRadius: -10,
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.deepNavy,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            title,
            style: AppStyles.getBold(
              context: context,
              color: Colors.white,
              fontSize: AppSize.s16,
            ),
          ),
        ),
      ),
    );
  }
}
