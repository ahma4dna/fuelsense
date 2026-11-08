import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/domain/models/failure.dart';
import '../entities/notification_entity.dart';
import '../repositories/notifications_repository.dart';

@lazySingleton
class GetNotificationsUseCase {
  final NotificationsRepository _repository;

  GetNotificationsUseCase(this._repository);

  Future<Either<Failure, List<NotificationEntity>>> call() {
    return _repository.getNotifications();
  }

  Stream<void> watchChanges() {
    return _repository.watchNotificationsStream();
  }
}
