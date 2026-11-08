import 'package:fpdart/fpdart.dart';
import 'package:fuelsense/core/data/network/safe_api_call.dart';
import 'package:fuelsense/core/data/network_info/network_info.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/domain/models/failure.dart';
import '../../domain/entities/account_profile_entity.dart';
import '../../domain/repositories/account_repository.dart';
import '../sources/account_remote_data_source.dart';

@LazySingleton(as: AccountRepository)
class AccountRepositoryImpl implements AccountRepository {
  final AccountRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  AccountRepositoryImpl({required this._remoteDataSource, required this._networkInfo});

  @override
  Future<Either<Failure, AccountProfileEntity>> getAccountProfile() async {
    return await safeApiCall(
      networkInfo: _networkInfo,
      apiCall: () async {
        final profile = await _remoteDataSource.getAccountProfile();
        return profile;
      },
    );
  }

  @override
  Future<Either<Failure, AccountProfileEntity>> updateAccountProfile({
    required String fullName,
  }) async {
    return await safeApiCall(
      networkInfo: _networkInfo,
      apiCall: () async {
        final updated = await _remoteDataSource.updateAccountProfile(
          fullName: fullName,
        );
        return updated;
      },
    );
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    return await safeApiCall(
      networkInfo: _networkInfo,
      apiCall: () async {
        await _remoteDataSource.signOut();
      },
    );
  }
}
