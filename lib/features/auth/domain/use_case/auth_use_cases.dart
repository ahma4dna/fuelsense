import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/domain/models/failure.dart';
import '../entities/user_profile_entity.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class SignInWithEmailUseCase {
  final AuthRepository _repository;
  SignInWithEmailUseCase(this._repository);

  Future<Either<Failure, UserProfileEntity>> call({
    required String email,
    required String password,
  }) {
    return _repository.signInWithEmail(email: email, password: password);
  }
}

@lazySingleton
class SignUpWithEmailUseCase {
  final AuthRepository _repository;
  SignUpWithEmailUseCase(this._repository);

  Future<Either<Failure, UserProfileEntity>> call({
    required String fullName,
    required String email,
    required String password,
  }) {
    return _repository.signUpWithEmail(
      fullName: fullName,
      email: email,
      password: password,
    );
  }
}

@lazySingleton
class SignInWithGoogleUseCase {
  final AuthRepository _repository;
  SignInWithGoogleUseCase(this._repository);

  Future<Either<Failure, UserProfileEntity>> call() {
    return _repository.signInWithGoogle();
  }
}

@lazySingleton
class ResetPasswordUseCase {
  final AuthRepository _repository;
  ResetPasswordUseCase(this._repository);

  Future<Either<Failure, void>> call(String email) {
    return _repository.resetPassword(email: email);
  }
}

@lazySingleton
class GetCurrentUserProfileUseCase {
  final AuthRepository _repository;
  GetCurrentUserProfileUseCase(this._repository);

  Future<Either<Failure, UserProfileEntity?>> call() {
    return _repository.getCurrentUserProfile();
  }
}

@lazySingleton
class SignOutUseCase {
  final AuthRepository _repository;
  SignOutUseCase(this._repository);

  Future<Either<Failure, void>> call() {
    return _repository.signOut();
  }
}

@lazySingleton
class UpdatePasswordUseCase {
  final AuthRepository _repository;
  UpdatePasswordUseCase(this._repository);

  Future<Either<Failure, void>> call(String newPassword) {
    return _repository.updatePassword(newPassword: newPassword);
  }
}
