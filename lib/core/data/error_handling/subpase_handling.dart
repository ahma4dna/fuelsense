import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/failure.dart';
import 'data_source.dart';
import 'data_source_extension.dart';

Failure postgresErrorHandling(PostgrestException error) {
  switch (error.code) {
    case PostgresCodes.duplicate:
      return DataSource.errorAccountAlreadyExists.getFailure();

    case PostgresCodes.phoneNotRegister:
      return DataSource.phoneNotRegister.getFailure();

    default:
      return DataSource.defaultError.getFailure();
  }
}

Failure authException(AuthException error) {
  switch (error.message) {
    case AuthExceptionMessage.failedSignInGoogle:
      return DataSource.defaultError.getFailure();
    default:
      return DataSource.defaultError.getFailure();
  }
}

class AuthExceptionMessage {
  static const failedSignInGoogle = "Failed to sign in with Google.";
}

class PostgresCodes {
  static const duplicate = "23505";
  static const phoneNotRegister = "phone-not-register";
}
