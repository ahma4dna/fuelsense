import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuelsense/core/application/resource/app_colors.dart';
import 'package:fuelsense/core/widget/smooth_animations.dart';
import 'package:fuelsense/di/injection.dart';
import 'package:fuelsense/features/notifications/presentation/widgets/category_filter_row.dart';
import 'package:fuelsense/features/notifications/presentation/widgets/empty%D9%80notifications_view.dart';
import 'package:fuelsense/features/notifications/presentation/widgets/loading/notifications_skeleton.dart';
import 'package:fuelsense/features/notifications/presentation/widgets/notification_card.dart';
import 'package:fuelsense/features/notifications/presentation/widgets/notifications_header.dart';
import 'package:gap/gap.dart';

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

  bool _entranceDone = false;
  Timer? _entranceTimer;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<NotificationsBloc>()..add(const LoadNotificationsEvent());
  }

  @override
  void dispose() {
    _entranceTimer?.cancel();
    _bloc.close();
    super.dispose();
  }

  void _armEntranceTimer() {
    _entranceTimer ??= Timer(const Duration(milliseconds: 1500), () {
      _entranceDone = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) {
          if (!state.isLoading) _armEntranceTimer();

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: const Color(0xFFF6F4EE),
              body: Column(
                children: [
                  FadeSlide(
                    dy: -24,
                    duration: const Duration(milliseconds: 650),
                    child: NotificationsHeader(
                      unreadCount: state.unreadCount,
                      todayCount: state.todayCount,
                      onMarkAllRead: state.unreadCount > 0
                          ? () {
                              HapticFeedback.lightImpact();
                              _bloc.add(const MarkAllNotificationsAsReadEvent());
                            }
                          : null,
                    ),
                  ),

                  FadeSlide(
                    delay: const Duration(milliseconds: 150),
                    dy: 16,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 16, 18, 10),
                      child: CategoryFilterRow(
                        selectedCategory: state.selectedCategory,
                        onSelectCategory: (cat) {
                          HapticFeedback.selectionClick();
                          _bloc.add(FilterNotificationsByCategoryEvent(cat));
                        },
                      ),
                    ),
                  ),

                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 450),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      child: state.isLoading
                          ? const NotificationsSkeleton(key: ValueKey('skeleton'))
                          : KeyedSubtree(
                              key: const ValueKey('content'),
                              child: _buildContent(state),
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

  Widget _buildContent(NotificationsState state) {
    return RefreshIndicator(
      color: const Color(0xFF0F6E67),
      backgroundColor: AppColors.white,
      onRefresh: () async {
        HapticFeedback.lightImpact();
        _bloc.add(
          const LoadNotificationsEvent(
            showLoading: false,
          ),
        );
        await Future<void>.delayed(const Duration(milliseconds: 700));
      },
      child: state.filteredNotifications.isEmpty
          ? const EmptyNotificationsView()
          : ListView.separated(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
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
                final card = NotificationCard(
                  notification: item,
                  onTap: () {
                    HapticFeedback.selectionClick();
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

                if (_entranceDone || index > 7) return card;
                return FadeSlide(
                  delay: Duration(milliseconds: 120 + index * 70),
                  dy: 32,
                  scaleFrom: 0.96,
                  duration: const Duration(milliseconds: 600),
                  child: card,
                );
              },
            ),
    );
  }
}
