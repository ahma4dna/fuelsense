import 'package:fpdart/fpdart.dart';
import 'package:fuelsense/core/data/network/safe_api_call.dart';
import 'package:fuelsense/core/data/network_info/network_info.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/domain/models/failure.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_source/auth_remote_data_source.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl({
    required this._networkInfo,
    required this._remoteDataSource,
  });

  @override
  Future<Either<Failure, UserProfileEntity>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await safeApiCall(
      networkInfo: _networkInfo,
      apiCall: () async {
        final profile = await _remoteDataSource.signInWithEmail(
          email: email,
          password: password,
        );
        return profile;
      },
    );
  }

  @override
  Future<Either<Failure, UserProfileEntity>> signUpWithEmail({
    required String fullName,
    required String email,
    required String password,
  }) async {
    return await safeApiCall(
      networkInfo: _networkInfo,
      apiCall: () async {
        final profile = await _remoteDataSource.signUpWithEmail(
          fullName: fullName,
          email: email,
          password: password,
        );
        return profile;
      },
    );
  }

  @override
  Future<Either<Failure, UserProfileEntity>> signInWithGoogle() async {
    return await safeApiCall(
      networkInfo: _networkInfo,
      apiCall: () async {
        final profile = await _remoteDataSource.signInWithGoogle();
        return profile;
      },
    );
  }

  @override
  Future<Either<Failure, void>> resetPassword({required String email}) async {
    return await safeApiCall(
      networkInfo: _networkInfo,
      apiCall: () async {
        final profile = await _remoteDataSource.resetPassword(
          email: email,
        );
        return profile;
      },
    );
  }

  @override
  Future<Either<Failure, UserProfileEntity?>> getCurrentUserProfile() async {
    return await safeApiCall(
      networkInfo: _networkInfo,
      apiCall: () async {
        final profile = await _remoteDataSource.getCurrentUserProfile();
        return profile;
      },
    );
  }

  @override
  Future<Either<Failure, void>> updatePassword({required String newPassword}) async {
    return await safeApiCall(
      networkInfo: _networkInfo,
      apiCall: () async {
        await _remoteDataSource.updatePassword(newPassword: newPassword);
      },
    );
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    return await safeApiCall(
      networkInfo: _networkInfo,
      apiCall: () async {
        final profile = await _remoteDataSource.signOut();
        return profile;
      },
    );
  }
  //TODO Use leater in extationion handel excption
  // String _mapSupabaseAuthError(String rawMessage) {
  //   final lower = rawMessage.toLowerCase();
  //   if (lower.contains('invalid login credentials')) {
  //     return 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
  //   }
  //   if (lower.contains('user already registered') || lower.contains('already exists')) {
  //     return 'هذا البريد الإلكتروني مسجل بالفعل، يمكنك تسجيل الدخول';
  //   }
  //   if (lower.contains('password should be at least')) {
  //     return 'كلمة المرور يجب أن تتكون من 8 أحرف على الأقل';
  //   }
  //   if (lower.contains('invalid format') || lower.contains('unable to validate email')) {
  //     return 'صيغة البريد الإلكتروني غير صحيحة';
  //   }
  //   return rawMessage;
  // }
}
