import 'package:flutter/material.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:gap/gap.dart';

class NotificationMetaHeader extends StatelessWidget {
  final String badgeLabel;
  final Color accentColor;
  final Color badgeBgColor;
  final String city;
  final DateTime createdAt;
  final bool isRead;

  const NotificationMetaHeader({
    super.key,
    required this.badgeLabel,
    required this.accentColor,
    required this.badgeBgColor,
    required this.city,
    required this.createdAt,
    required this.isRead,
  });

  String _formatRelativeTime(AppContext appContext, DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return appContext.localText.time_now;
    if (diff.inMinutes < 60) {
      return appContext.localText.time_minutes_ago(diff.inMinutes);
    }
    if (diff.inHours < 24) {
      return appContext.localText.time_hours_ago(diff.inHours);
    }
    return '${dateTime.year}/${dateTime.month}/${dateTime.day}';
  }

  @override
  Widget build(BuildContext context) {
    final appContext = AppContext.of(context);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.p8,
            vertical: AppPadding.p4,
          ),
          decoration: BoxDecoration(
            color: badgeBgColor,
            borderRadius: BorderRadius.circular(AppSize.s8),
          ),
          child: Text(
            badgeLabel,
            style: AppStyles.getBold(
              context: context,
              fontSize: AppSize.s12,
              color: accentColor,
            ),
          ),
        ),
        const Gap(AppSize.s6),
        if (city.isNotEmpty)
          Text(
            '• $city',
            style: AppStyles.getMeduim(
              context: context,
              fontSize: AppSize.s12,
              color: const Color(0xFF6B7B79),
            ),
          ),
        const Spacer(),
        Text(
          _formatRelativeTime(appContext, createdAt),
          style: AppStyles.getMeduim(
            context: context,
            fontSize: AppSize.s12,
            color: const Color(0xFF8C9896),
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, animation) => ScaleTransition(
            scale: animation,
            child: child,
          ),
          child: isRead
              ? const SizedBox.shrink(key: ValueKey('read'))
              : Row(
                  key: const ValueKey('unread'),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Gap(AppSize.s6),
                    Container(
                      width: AppSize.s8,
                      height: AppSize.s8,
                      decoration: BoxDecoration(
                        color: accentColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
