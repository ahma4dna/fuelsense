import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuelsense/di/injection.dart';
import 'package:gap/gap.dart';

import '../../domain/entities/notification_entity.dart';
import '../bloc/notifications_bloc.dart';
import '../bloc/notifications_event.dart';
import '../bloc/notifications_state.dart';

class NotificationsScreen extends StatefulWidget {
  final ValueChanged<int>? onStationTap;

  const NotificationsScreen({
    super.key,
    this.onStationTap,
  });

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final NotificationsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<NotificationsBloc>()..add(const LoadNotificationsEvent());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: const Color(0xFFF6F4EE),
              body: Column(
                children: [
                  // 1. الهيدر العلوي الأخضر الداكن
                  _NotificationsHeader(
                    unreadCount: state.unreadCount,
                    todayCount: state.todayCount,
                    onMarkAllRead: state.unreadCount > 0
                        ? () => _bloc.add(
                            const MarkAllNotificationsAsReadEvent(),
                          )
                        : null,
                  ),

                  // 2. أزرار التصفية حسب نوع الإشعار
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 10),
                    child: _CategoryFilterRow(
                      selectedCategory: state.selectedCategory,
                      onSelectCategory: (cat) => _bloc.add(
                        FilterNotificationsByCategoryEvent(cat),
                      ),
                    ),
                  ),

                  // 3. قائمة الإشعارات
                  Expanded(
                    child: state.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF0F6E67),
                            ),
                          )
                        : RefreshIndicator(
                            color: const Color(0xFF0F6E67),
                            onRefresh: () async {
                              _bloc.add(
                                const LoadNotificationsEvent(
                                  showLoading: false,
                                ),
                              );
                            },
                            child: state.filteredNotifications.isEmpty
                                ? const _EmptyNotificationsView()
                                : ListView.separated(
                                    padding: const EdgeInsets.fromLTRB(
                                      18,
                                      6,
                                      18,
                                      28,
                                    ),
                                    itemCount: state.filteredNotifications.length,
                                    separatorBuilder: (_, _) => const Gap(12),
                                    itemBuilder: (context, index) {
                                      final item = state.filteredNotifications[index];
                                      return _NotificationCard(
                                        notification: item,
                                        onTap: () {
                                          _bloc.add(
                                            MarkNotificationAsReadEvent(
                                              item.id,
                                            ),
                                          );
                                          if (item.stationId != null) {
                                            widget.onStationTap?.call(
                                              item.stationId!,
                                            );
                                          }
                                        },
                                      );
                                    },
                                  ),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NotificationsHeader extends StatelessWidget {
  final int unreadCount;
  final int todayCount;
  final VoidCallback? onMarkAllRead;

  const _NotificationsHeader({
    required this.unreadCount,
    required this.todayCount,
    this.onMarkAllRead,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF07332C),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (Navigator.of(context).canPop()) ...[
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const Gap(4),
                  ],
                  const Expanded(
                    child: Text(
                      'مركز الإشعارات',
                      style: TextStyle(
                        fontFamily: 'IBM Plex Sans Arabic',
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (onMarkAllRead != null)
                    TextButton.icon(
                      onPressed: onMarkAllRead,
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFF0E453D),
                        foregroundColor: const Color(0xFF64FFDA),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.done_all_rounded, size: 17),
                      label: const Text(
                        'تحديد الكل كمقروء',
                        style: TextStyle(
                          fontFamily: 'IBM Plex Sans Arabic',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
              const Gap(14),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A3D35),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF175249)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.notifications_active_outlined,
                      color: Color(0xFF53C0B2),
                      size: 20,
                    ),
                    const Gap(10),
                    Expanded(
                      child: Text(
                        'تنبيهات اليوم: $todayCount إشعاراً من لجان التوزيع',
                        style: const TextStyle(
                          fontFamily: 'IBM Plex Sans Arabic',
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFE5F2F0),
                        ),
                      ),
                    ),
                    if (unreadCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF22C55E),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$unreadCount جديد',
                          style: const TextStyle(
                            fontFamily: 'IBM Plex Sans Arabic',
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryFilterRow extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onSelectCategory;

  const _CategoryFilterRow({
    required this.selectedCategory,
    required this.onSelectCategory,
  });

  @override
  Widget build(BuildContext context) {
    final filters = [
      ('all', 'الكل'),
      ('open', 'مفتوحة الآن'),
      ('refilling', 'تم التفريغ'),
      ('on_the_way', 'في الطريق'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((item) {
          final isSelected = selectedCategory == item.$1;
          return Padding(
            padding: const EdgeInsetsDirectional.only(end: 8),
            child: GestureDetector(
              onTap: () => onSelectCategory(item.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF0E2925) : const Color(0xFFF3F1EA),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF0E2925) : const Color(0xFFE2DFD5),
                  ),
                ),
                child: Text(
                  item.$2,
                  style: TextStyle(
                    fontFamily: 'IBM Plex Sans Arabic',
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: isSelected ? Colors.white : const Color(0xFF374543),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.notification,
    required this.onTap,
  });

  ({
    IconData icon,
    Color accentColor,
    Color iconBgColor,
    String badgeLabel,
  })
  _resolveStyle() {
    switch (notification.resolvedStatusCategory) {
      case 'open':
        return (
          icon: Icons.local_gas_station_rounded,
          accentColor: const Color(0xFF16A34A),
          iconBgColor: const Color(0xFFDCFCE7),
          badgeLabel: 'مفتوحة وتعمل',
        );
      case 'refilling':
        return (
          icon: Icons.water_drop_rounded,
          accentColor: const Color(0xFFD97706),
          iconBgColor: const Color(0xFFFEF3C7),
          badgeLabel: 'تفريغ وقود',
        );
      case 'on_the_way':
        return (
          icon: Icons.local_shipping_rounded,
          accentColor: const Color(0xFF2563EB),
          iconBgColor: const Color(0xFFDBEAFE),
          badgeLabel: 'في الطريق',
        );
      case 'out_of_fuel':
        return (
          icon: Icons.warning_amber_rounded,
          accentColor: const Color(0xFFDC2626),
          iconBgColor: const Color(0xFFFEE2E2),
          badgeLabel: 'نفد الوقود',
        );
      default:
        return (
          icon: Icons.campaign_rounded,
          accentColor: const Color(0xFF0F6E67),
          iconBgColor: const Color(0xFFEEF9F7),
          badgeLabel: 'تحديث رسمي',
        );
    }
  }

  String _formatRelativeTime(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'الآن';
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
    return '${dateTime.year}/${dateTime.month}/${dateTime.day}';
  }

  @override
  Widget build(BuildContext context) {
    final style = _resolveStyle();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.white : const Color(0xFFFCFDFD),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: style.accentColor,
                  width: 4.5,
                ),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // أيقونة نوع الإشعار
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: style.iconBgColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    style.icon,
                    color: style.accentColor,
                    size: 24,
                  ),
                ),
                const Gap(12),

                // محتوى الإشعار
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: style.iconBgColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              style.badgeLabel,
                              style: TextStyle(
                                fontFamily: 'IBM Plex Sans Arabic',
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: style.accentColor,
                              ),
                            ),
                          ),
                          const Gap(6),
                          if (notification.city.isNotEmpty)
                            Text(
                              '• ${notification.city}',
                              style: const TextStyle(
                                fontFamily: 'IBM Plex Sans Arabic',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF6B7B79),
                              ),
                            ),
                          const Spacer(),
                          Text(
                            _formatRelativeTime(notification.createdAt),
                            style: const TextStyle(
                              fontFamily: 'IBM Plex Sans Arabic',
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF8C9896),
                            ),
                          ),
                          if (!notification.isRead) ...[
                            const Gap(6),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: style.accentColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const Gap(8),
                      Text(
                        notification.body,
                        style: TextStyle(
                          fontFamily: 'IBM Plex Sans Arabic',
                          fontSize: 14.5,
                          fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.w800,
                          color: const Color(0xFF11201F),
                          height: 1.5,
                        ),
                      ),
                      if (notification.stationId != null) ...[
                        const Gap(8),
                        const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'عرض تفاصيل المحطة على الخريطة',
                              style: TextStyle(
                                fontFamily: 'IBM Plex Sans Arabic',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0F6E67),
                              ),
                            ),
                            Gap(4),
                            Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 11,
                              color: Color(0xFF0F6E67),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyNotificationsView extends StatelessWidget {
  const _EmptyNotificationsView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(32),
      children: [
        const Gap(60),
        Container(
          width: 82,
          height: 82,
          decoration: const BoxDecoration(
            color: Color(0xFFEEF9F7),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.notifications_none_rounded,
            size: 42,
            color: Color(0xFF0F6E67),
          ),
        ),
        const Gap(18),
        const Text(
          'لا توجد إشعارات حالياً',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'IBM Plex Sans Arabic',
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF11201F),
          ),
        ),
        const Gap(8),
        const Text(
          'ستصلك التنبيهات هنا وفوق شاشة هاتفك فور صدور أي بيان جديد حول توفر الوقود في المحطات.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'IBM Plex Sans Arabic',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF5A6866),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
