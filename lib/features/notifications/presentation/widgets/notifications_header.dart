import 'package:flutter/material.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:gap/gap.dart';

class NotificationsHeader extends StatelessWidget {
  final int unreadCount;
  final int todayCount;
  final VoidCallback? onMarkAllRead;

  const NotificationsHeader({
    super.key,
    required this.unreadCount,
    required this.todayCount,
    this.onMarkAllRead,
  });

  @override
  Widget build(BuildContext context) {
    final appContext = AppContext.of(context);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF07332C),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppSize.s28),
          bottomRight: Radius.circular(AppSize.s28),
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
              Row(
                children: [
                  if (Navigator.of(context).canPop()) ...[
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: Icon(
                        appContext.isRt ? Icons.chevron_right_rounded : Icons.chevron_left_rounded,
                        color: Colors.white,
                        size: AppSize.s28,
                      ),
                    ),
                    const Gap(AppSize.s4),
                  ],
                  Expanded(
                    child: Text(
                      appContext.localText.notifications_center_title,
                      style: AppStyles.getExtraBold(
                        context: context,
                        fontSize: AppSize.s25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(AppSize.s14),
              NotificationsTodaySummaryCard(todayCount: todayCount),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationsTodaySummaryCard extends StatelessWidget {
  final int todayCount;

  const NotificationsTodaySummaryCard({
    super.key,
    required this.todayCount,
  });

  @override
  Widget build(BuildContext context) {
    final appContext = AppContext.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p16,
        vertical: AppPadding.p12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0A3D35),
        borderRadius: BorderRadius.circular(AppSize.s16),
        border: Border.all(
          color: const Color(0xFF175249),
          width: AppSize.s1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.notifications_active_outlined,
            color: Color(0xFF53C0B2),
            size: AppSize.s20,
          ),
          const Gap(AppSize.s10),
          Expanded(
            child: Text(
              "${appContext.localText.today_alerts_count} $todayCount",
              style: AppStyles.getMeduim(
                context: context,
                fontSize: AppSize.s13_5,
                color: const Color(0xFFE5F2F0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
