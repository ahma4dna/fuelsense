import 'package:fpdart/fpdart.dart';
import 'package:fuelsense/core/data/network/safe_api_call.dart';
import 'package:fuelsense/core/data/network_info/network_info.dart';
import 'package:fuelsense/features/notifications/data/sources/notifications_remote_data_source.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/domain/models/failure.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notifications_repository.dart';

@LazySingleton(as: NotificationsRepository)
class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  NotificationsRepositoryImpl({required this._remoteDataSource, required this._networkInfo});

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() async {
    return safeApiCall(
      networkInfo: _networkInfo,
      apiCall: () async {
        final list = await _remoteDataSource.getNotifications();
        return list;
      },
    );
  }

  @override
  Stream<void> watchNotificationsStream() async* {
    yield safeApiCall(
      networkInfo: _networkInfo,
      apiCall: () async {
        _remoteDataSource.watchNotificationsStream();
      },
    );
  }
}
