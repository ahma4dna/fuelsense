import 'dart:developer';

import 'package:fuelsense/core/data/error_handling/subpase_handling.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/failure.dart';
import 'data_source.dart';
import 'data_source_extension.dart';

class ErrorHandling implements Exception {
  late Failure failure;

  ErrorHandling.handel(dynamic error) {
    if (error is PostgrestException) {
      failure = postgresErrorHandling(error);
      log(error.toString());
    } else if (error is AuthApiException) {
      failure = authException(error);
      log(error.toString());
    } else {
      log(error.toString());
      failure = DataSource.defaultError.getFailure();
    }
  }
}
