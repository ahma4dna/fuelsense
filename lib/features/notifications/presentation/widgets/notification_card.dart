import 'package:flutter/material.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:fuelsense/core/widget/smooth_animations.dart';
import 'package:fuelsense/features/notifications/domain/entities/notification_entity.dart';
import 'package:fuelsense/features/notifications/presentation/widgets/notification_meta_header.dart';
import 'package:fuelsense/features/notifications/presentation/widgets/notification_status_icon_box.dart';
import 'package:gap/gap.dart';

class NotificationCard extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  ({
    IconData icon,
    Color accentColor,
    Color iconBgColor,
    String badgeLabel,
  })
  _resolveStyle(AppContext appContext) {
    switch (notification.resolvedStatusCategory) {
      case 'open':
        return (
          icon: Icons.local_gas_station_rounded,
          accentColor: const Color(0xFF16A34A),
          iconBgColor: const Color(0xFFDCFCE7),
          badgeLabel: appContext.localText.notif_status_open,
        );
      case 'refilling':
        return (
          icon: Icons.water_drop_rounded,
          accentColor: const Color(0xFFD97706),
          iconBgColor: const Color(0xFFFEF3C7),
          badgeLabel: appContext.localText.notif_status_refilling,
        );
      case 'on_the_way':
        return (
          icon: Icons.local_shipping_rounded,
          accentColor: const Color(0xFF2563EB),
          iconBgColor: const Color(0xFFDBEAFE),
          badgeLabel: appContext.localText.notif_status_on_the_way,
        );
      case 'out_of_fuel':
        return (
          icon: Icons.warning_amber_rounded,
          accentColor: const Color(0xFFDC2626),
          iconBgColor: const Color(0xFFFEE2E2),
          badgeLabel: appContext.localText.notif_status_out_of_fuel,
        );
      default:
        return (
          icon: Icons.campaign_rounded,
          accentColor: const Color(0xFF0F6E67),
          iconBgColor: const Color(0xFFEEF9F7),
          badgeLabel: appContext.localText.notif_status_official_update,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appContext = AppContext.of(context);
    final style = _resolveStyle(appContext);

    return PressScale(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: notification.isRead ? Colors.white : const Color(0xFFFCFDFD),
            borderRadius: BorderRadius.circular(AppSize.s20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: AppSize.s0_02),
                blurRadius: AppSize.s10,
                offset: const Offset(AppSize.s0, AppSize.s4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSize.s20),
            child: Container(
              decoration: BoxDecoration(
                border: BorderDirectional(
                  start: BorderSide(
                    color: style.accentColor,
                    width: AppSize.s4,
                  ),
                ),
              ),
              padding: const EdgeInsets.all(AppPadding.p16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NotificationStatusIconBox(
                    icon: style.icon,
                    accentColor: style.accentColor,
                    backgroundColor: style.iconBgColor,
                  ),
                  const Gap(AppSize.s12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NotificationMetaHeader(
                          badgeLabel: style.badgeLabel,
                          accentColor: style.accentColor,
                          badgeBgColor: style.iconBgColor,
                          city: notification.city,
                          createdAt: notification.createdAt,
                          isRead: notification.isRead,
                        ),
                        const Gap(AppSize.s8),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                          style:
                              (notification.isRead
                                      ? AppStyles.getMeduim(
                                          context: context,
                                          fontSize: AppSize.s14_5,
                                          color: const Color(0xFF11201F),
                                        )
                                      : AppStyles.getExtraBold(
                                          context: context,
                                          fontSize: AppSize.s14_5,
                                          color: const Color(0xFF11201F),
                                        ))
                                  .copyWith(height: AppSize.s1_5),
                          child: Text(notification.body),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
