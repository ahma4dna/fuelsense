import 'package:fpdart/fpdart.dart';

import '../../../../core/domain/models/failure.dart';
import '../entities/user_profile_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserProfileEntity>> signInWithEmail({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserProfileEntity>> signUpWithEmail({
    required String fullName,
    required String email,
    required String password,
  });

  Future<Either<Failure, UserProfileEntity>> signInWithGoogle();

  Future<Either<Failure, void>> resetPassword({required String email});

  Future<Either<Failure, void>> updatePassword({required String newPassword});

  Future<Either<Failure, UserProfileEntity?>> getCurrentUserProfile();

  Future<Either<Failure, void>> signOut();
}
