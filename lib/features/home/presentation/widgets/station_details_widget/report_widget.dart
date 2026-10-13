import 'package:flutter/material.dart';
import 'package:fuelsense/core/application/resource/app_colors.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:gap/gap.dart';

class ReportWidget extends StatelessWidget {
  const new({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.p16,
        vertical: AppPadding.p10,
      ),
      margin: EdgeInsets.only(
        bottom: AppPadding.p10,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 2,
            offset: Offset(0, 1),
            spreadRadius: -1,
          ),
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 3,
            offset: Offset(0, 1),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color(0xB2E1E8F0),
            blurRadius: 0,
            offset: Offset(0, 0),
            spreadRadius: 1,
          ),
        ],
        borderRadius: BorderRadius.circular(AppSize.s22),
        border: Border.all(
          width: 1,
          color: AppColors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.deepNavy,
          ),
          const Gap(AppSize.s10),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    "احمد الناجي",
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: AppStyles.getExtraBold(
                      context: context,
                      color: const Color(0xFF0F172A),
                      fontSize: AppSize.s20,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    "يوجد وقود",
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: AppStyles.getExtraBold(
                      context: context,
                      color: AppColors.primary,
                      fontSize: AppSize.s18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Container(
                    height: AppSize.s45,
                    width: AppSize.s45,
                    decoration: BoxDecoration(
                      color: AppColors.lightBackground,
                      border: Border.all(width: 2, color: AppColors.border),
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xB20F172A),
                          blurRadius: AppSize.s24,
                          offset: Offset(AppSize.s0, AppSize.s10),
                          spreadRadius: -AppSize.s10,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.thumb_up,
                      size: AppSize.s26,
                    ),
                  ),
                ),

                Flexible(
                  child: Container(
                    height: AppSize.s45,
                    width: AppSize.s45,
                    decoration: BoxDecoration(
                      color: AppColors.lightBackground,
                      border: Border.all(width: 2, color: AppColors.border),
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xB20F172A),
                          blurRadius: AppSize.s24,
                          offset: Offset(AppSize.s0, AppSize.s10),
                          spreadRadius: -AppSize.s10,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.thumb_down,
                      size: AppSize.s26,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
