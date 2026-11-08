import 'package:equatable/equatable.dart';

sealed class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

final class LoadNotificationsEvent extends NotificationsEvent {
  final bool showLoading;
  const LoadNotificationsEvent({this.showLoading = true});

  @override
  List<Object?> get props => [showLoading];
}

final class FilterNotificationsByCategoryEvent extends NotificationsEvent {
  final String category; // 'all', 'open', 'refilling', 'on_the_way'
  const FilterNotificationsByCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

final class MarkNotificationAsReadEvent extends NotificationsEvent {
  final int notificationId;
  const MarkNotificationAsReadEvent(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

final class MarkAllNotificationsAsReadEvent extends NotificationsEvent {
  const MarkAllNotificationsAsReadEvent();
}
