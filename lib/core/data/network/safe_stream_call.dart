import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/failure.dart';
import '../error_handling/data_source.dart';
import '../error_handling/data_source_extension.dart';
import '../error_handling/error_handling.dart';
import '../network_info/network_info.dart';

Stream<Either<Failure, T>> safeStreamCall<T>({
  required NetworkInfo networkInfo,
  required Stream<T> Function() apiCall,
}) async* {
  if (!await networkInfo.isConnected) {
    yield Left(DataSource.noInternetConnection.getFailure());
    return;
  }

  try {
    final stream = apiCall();

    await for (final data in stream) {
      yield Right(data);
    }
  } on PostgrestException catch (error) {
    yield Left(ErrorHandling.handel(error).failure);
  } on Failure catch (error) {
    yield Left(ErrorHandling.handel(error).failure);
  } catch (error) {
    yield Left(ErrorHandling.handel(error).failure);
  }
}
