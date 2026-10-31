import 'package:flutter/material.dart';
import 'package:fuelsense/core/application/resource/app_colors.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';

class TabBarStationHistoryWidget extends StatelessWidget {
  final int selectIndexTab;
  final int todayReportsCount;
  final void Function()? onTapTodayReportSelect;
  final void Function()? onTapHitoryAndDate;

  const TabBarStationHistoryWidget({
    super.key,
    required this.selectIndexTab,
    required this.todayReportsCount,
    this.onTapTodayReportSelect,
    this.onTapHitoryAndDate,
  });

  @override
  Widget build(BuildContext context) {
    final AppContext appContext = AppContext.of(context);
    return Container(
      height: AppSize.s52,
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.symmetric(
        horizontal: AppPadding.p20,
      ),
      decoration: ShapeDecoration(
        color: const Color(0x99E6E1D8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = constraints.maxWidth / 2;

          return Stack(
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: selectIndexTab == 0 ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: tabWidth,
                  height: AppSize.s44,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onTapTodayReportSelect,
                      child: Center(
                        child: Text(
                          "${appContext.localText.reports_today_uers}($todayReportsCount)",
                          textAlign: TextAlign.center,
                          style: AppStyles.getBold(
                            context: context,
                            color: const Color(0xFF083A38),
                            fontSize: AppSize.s13,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onTapHitoryAndDate,
                      child: Center(
                        child: Text(
                          appContext.localText.history_and_date_station,
                          textAlign: TextAlign.center,
                          style: AppStyles.getBold(
                            context: context,
                            color: const Color(0xFF083A38),
                            fontSize: AppSize.s13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
