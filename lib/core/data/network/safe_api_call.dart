import 'package:fpdart/fpdart.dart';
import 'package:fuelsense/core/domain/models/failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../error_handling/data_source.dart';
import '../error_handling/data_source_extension.dart';
import '../error_handling/error_handling.dart';
import '../network_info/network_info.dart';

Future<Either<Failure, T>> safeApiCall<T>({
  required NetworkInfo networkInfo,
  required Future<T> Function() apiCall,
}) async {
  if (!await networkInfo.isConnected) {
    return Left(DataSource.noInternetConnection.getFailure());
  } else {
    try {
      final response = await apiCall();
      return Right(response);
    } on PostgrestException catch (error) {
      return Left(ErrorHandling.handel(error).failure);
    } on AuthApiException catch (error) {
      return Left(ErrorHandling.handel(error).failure);
    } on AuthException catch (error) {
      return Left(ErrorHandling.handel(error).failure);
    } on Failure catch (error) {
      return Left(ErrorHandling.handel(error).failure);
    } catch (error) {
      return Left(ErrorHandling.handel(error).failure);
    }
  }
}
