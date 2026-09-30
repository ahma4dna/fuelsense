import 'package:fuelsense/core/data/error_handling/response_code.dart';

import '../../domain/models/failure.dart';
import 'data_source.dart';

extension DataSourceExtension on DataSource {
  Failure getFailure() {
    switch (this) {
      case DataSource.noInternetConnection:
        return Failure(code: ResponseCode.noInternetConnection, localMessage: DataSource.noInternetConnection);

      case DataSource.defaultError:
        return Failure(code: ResponseCode.defaultError, localMessage: DataSource.defaultError);
      case DataSource.errorAccountAlreadyExists:
        return Failure(
          code: ResponseCode.errorAccountAlreadyExists,
          localMessage: DataSource.errorAccountAlreadyExists,
        );
      case DataSource.phoneNotRegister:
        return Failure(code: ResponseCode.phoneNotRegister, localMessage: DataSource.phoneNotRegister);
    }
  }
}
