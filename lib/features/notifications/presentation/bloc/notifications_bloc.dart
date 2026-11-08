import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuelsense/features/notifications/domain/usecases/get_notifications_use_case.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/notification_entity.dart';
import 'notifications_event.dart';
import 'notifications_state.dart';

@injectable
class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final GetNotificationsUseCase _getNotificationsUseCase;
  StreamSubscription<void>? _realtimeSub;

  NotificationsBloc(this._getNotificationsUseCase) : super(const NotificationsState()) {
    on<LoadNotificationsEvent>(_onLoadNotifications);
    on<FilterNotificationsByCategoryEvent>(_onFilterByCategory);
    on<MarkNotificationAsReadEvent>(_onMarkAsRead);
    on<MarkAllNotificationsAsReadEvent>(_onMarkAllAsRead);

    _realtimeSub = _getNotificationsUseCase.watchChanges().listen((_) {
      add(const LoadNotificationsEvent(showLoading: false));
    });
  }

  Future<void> _onLoadNotifications(
    LoadNotificationsEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    if (event.showLoading) {
      emit(state.copyWith(isLoading: true));
    }

    final result = await _getNotificationsUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          errorMessage: "",
        ),
      ),
      (notifications) {
        _applyFilterAndEmit(
          emit: emit,
          all: notifications,
          category: state.selectedCategory,
          readIds: state.readIds,
        );
      },
    );
  }

  void _onFilterByCategory(
    FilterNotificationsByCategoryEvent event,
    Emitter<NotificationsState> emit,
  ) {
    _applyFilterAndEmit(
      emit: emit,
      all: state.allNotifications,
      category: event.category,
      readIds: state.readIds,
    );
  }

  void _onMarkAsRead(
    MarkNotificationAsReadEvent event,
    Emitter<NotificationsState> emit,
  ) {
    final updatedReadIds = Set<int>.from(state.readIds)..add(event.notificationId);
    _applyFilterAndEmit(
      emit: emit,
      all: state.allNotifications,
      category: state.selectedCategory,
      readIds: updatedReadIds,
    );
  }

  void _onMarkAllAsRead(
    MarkAllNotificationsAsReadEvent event,
    Emitter<NotificationsState> emit,
  ) {
    final allIds = state.allNotifications.map((e) => e.id).toSet();
    _applyFilterAndEmit(
      emit: emit,
      all: state.allNotifications,
      category: state.selectedCategory,
      readIds: allIds,
    );
  }

  void _applyFilterAndEmit({
    required Emitter<NotificationsState> emit,
    required List<NotificationEntity> all,
    required String category,
    required Set<int> readIds,
  }) {
    final enriched = all.map((n) => n.copyWith(isRead: readIds.contains(n.id))).toList();

    final filtered = category == 'all'
        ? enriched
        : enriched.where((n) => n.resolvedStatusCategory == category).toList();

    emit(
      state.copyWith(
        isLoading: false,
        allNotifications: enriched,
        filteredNotifications: filtered,
        selectedCategory: category,
        readIds: readIds,
      ),
    );
  }

  @override
  Future<void> close() {
    _realtimeSub?.cancel();
    return super.close();
  }
}
