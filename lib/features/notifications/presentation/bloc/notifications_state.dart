import 'package:equatable/equatable.dart';

import '../../domain/entities/notification_entity.dart';

class NotificationsState extends Equatable {
  final bool isLoading;
  final List<NotificationEntity> allNotifications;
  final List<NotificationEntity> filteredNotifications;
  final String selectedCategory; // 'all', 'open', 'refilling', 'on_the_way'
  final Set<int> readIds;
  final String? errorMessage;

  const NotificationsState({
    this.isLoading = true,
    this.allNotifications = const [],
    this.filteredNotifications = const [],
    this.selectedCategory = 'all',
    this.readIds = const {},
    this.errorMessage,
  });

  int get unreadCount => allNotifications.where((n) => !readIds.contains(n.id)).length;

  int get todayCount {
    final now = DateTime.now();
    return allNotifications
        .where(
          (n) => n.createdAt.year == now.year && n.createdAt.month == now.month && n.createdAt.day == now.day,
        )
        .length;
  }

  NotificationsState copyWith({
    bool? isLoading,
    List<NotificationEntity>? allNotifications,
    List<NotificationEntity>? filteredNotifications,
    String? selectedCategory,
    Set<int>? readIds,
    String? errorMessage,
  }) {
    return NotificationsState(
      isLoading: isLoading ?? this.isLoading,
      allNotifications: allNotifications ?? this.allNotifications,
      filteredNotifications: filteredNotifications ?? this.filteredNotifications,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      readIds: readIds ?? this.readIds,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    allNotifications,
    filteredNotifications,
    selectedCategory,
    readIds,
    errorMessage,
  ];
}
