import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/domain/models/failure.dart';
import '../entities/account_profile_entity.dart';
import '../repositories/account_repository.dart';

@lazySingleton
class GetAccountProfileUseCase {
  final AccountRepository _repository;
  GetAccountProfileUseCase(this._repository);

  Future<Either<Failure, AccountProfileEntity>> call() {
    return _repository.getAccountProfile();
  }
}

@lazySingleton
class UpdateAccountProfileUseCase {
  final AccountRepository _repository;
  UpdateAccountProfileUseCase(this._repository);

  Future<Either<Failure, AccountProfileEntity>> call({
    required String fullName,
  }) {
    return _repository.updateAccountProfile(
      fullName: fullName,
    );
  }
}

@lazySingleton
class SignOutAccountUseCase {
  final AccountRepository _repository;
  SignOutAccountUseCase(this._repository);

  Future<Either<Failure, void>> call() {
    return _repository.signOut();
  }
}
