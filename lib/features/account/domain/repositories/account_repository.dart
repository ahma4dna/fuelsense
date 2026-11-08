import 'package:fpdart/fpdart.dart';

import '../../../../core/domain/models/failure.dart';
import '../entities/account_profile_entity.dart';

abstract class AccountRepository {
  Future<Either<Failure, AccountProfileEntity>> getAccountProfile();

  Future<Either<Failure, AccountProfileEntity>> updateAccountProfile({
    required String fullName,
  });

  Future<Either<Failure, void>> signOut();
}
