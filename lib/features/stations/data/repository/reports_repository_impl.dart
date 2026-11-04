import 'package:fpdart/fpdart.dart';
import 'package:fuelsense/core/data/network/safe_api_call.dart';
import 'package:fuelsense/core/data/network_info/network_info.dart';
import 'package:fuelsense/features/stations/data/sources/reports_remote_data_source.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/domain/models/failure.dart';
import '../../domain/entities/create_report_params.dart';
import '../../domain/repositories/reports_repository.dart';

@LazySingleton(as: ReportsRepository)
class ReportsRepositoryImpl implements ReportsRepository {
  final ReportsRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  ReportsRepositoryImpl({
    required this._networkInfo,
    required this._remoteDataSource,
  });

  @override
  Future<Either<Failure, void>> submitStationReport(
    CreateReportParams params,
  ) async {
    return safeApiCall(
      networkInfo: _networkInfo,
      apiCall: () async {
        await _remoteDataSource.submitStationReport(params);
      },
    );
  }
}
