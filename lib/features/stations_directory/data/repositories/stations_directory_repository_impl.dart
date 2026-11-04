import 'package:fpdart/fpdart.dart';
import 'package:fuelsense/core/data/network/safe_api_call.dart';
import 'package:fuelsense/core/data/network/safe_stream_call.dart';
import 'package:fuelsense/core/data/network_info/network_info.dart';
import 'package:fuelsense/features/stations_directory/data/sources/stations_directory_remote_data_source.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/domain/models/failure.dart';
import '../../domain/entities/station_directory_entity.dart';
import '../../domain/repositories/stations_directory_repository.dart';

@LazySingleton(as: StationsDirectoryRepository)
class StationsDirectoryRepositoryImpl implements StationsDirectoryRepository {
  final StationsDirectoryRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  StationsDirectoryRepositoryImpl({
    required this._networkInfo,
    required this._remoteDataSource,
  });

  @override
  Future<Either<Failure, List<StationDirectoryEntity>>> getStationsDirectory() async {
    return safeApiCall(
      networkInfo: _networkInfo,
      apiCall: () async {
        final stations = await _remoteDataSource.getStationsDirectory();
        return stations;
      },
    );
  }

  @override
  Stream<void> watchStationsChanges() async* {
    yield* safeStreamCall(
      networkInfo: _networkInfo,
      apiCall: () async* {
        final stations = await _remoteDataSource.getStationsDirectory();
        yield stations;
      },
    );
  }
}
