// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:fuelsense/core/data/di/core_module.dart' as _i215;
import 'package:fuelsense/core/data/network_info/network_info.dart' as _i628;
import 'package:fuelsense/features/stations/data/repository/stations_repository_imp.dart'
    as _i281;
import 'package:fuelsense/features/stations/domain/repositories/stations_repository.dart'
    as _i245;
import 'package:fuelsense/features/stations/domain/use_case/stations_use_cases.dart'
    as _i545;
import 'package:fuelsense/features/stations/presentation/bloc/stations_bloc.dart'
    as _i168;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final coreModule = _$CoreModule();
    gh.lazySingleton<_i454.SupabaseClient>(() => coreModule.supabaseClient());
    gh.lazySingleton<_i628.NetworkInfo>(() => coreModule.networkInfo());
    gh.lazySingleton<_i245.StationsRepository>(
      () => _i281.StationsRepositoryImp(
        supabaseClient: gh<_i454.SupabaseClient>(),
        networkInfo: gh<_i628.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i545.WatchStationsUseCase>(
      () => _i545.WatchStationsUseCase(gh<_i245.StationsRepository>()),
    );
    gh.lazySingleton<_i545.WatchTodayReportsUseCase>(
      () => _i545.WatchTodayReportsUseCase(gh<_i245.StationsRepository>()),
    );
    gh.lazySingleton<_i545.GetStationHistoryUseCase>(
      () => _i545.GetStationHistoryUseCase(gh<_i245.StationsRepository>()),
    );
    gh.lazySingleton<_i545.GetHistoryReportsUseCase>(
      () => _i545.GetHistoryReportsUseCase(gh<_i245.StationsRepository>()),
    );
    gh.lazySingleton<_i545.SubmitFieldReportUseCase>(
      () => _i545.SubmitFieldReportUseCase(gh<_i245.StationsRepository>()),
    );
    gh.lazySingleton<_i545.ConfirmFieldReportUseCase>(
      () => _i545.ConfirmFieldReportUseCase(gh<_i245.StationsRepository>()),
    );
    gh.lazySingleton<_i545.GetUserConfirmedReportIdsUseCase>(
      () => _i545.GetUserConfirmedReportIdsUseCase(
        gh<_i245.StationsRepository>(),
      ),
    );
    gh.lazySingleton<_i545.GetFavoriteStationIdsUseCase>(
      () => _i545.GetFavoriteStationIdsUseCase(gh<_i245.StationsRepository>()),
    );
    gh.lazySingleton<_i545.ToggleFavoriteStationUseCase>(
      () => _i545.ToggleFavoriteStationUseCase(gh<_i245.StationsRepository>()),
    );
    gh.lazySingleton<_i168.StationsBloc>(
      () => _i168.StationsBloc(
        watchStationsUseCase: gh<_i545.WatchStationsUseCase>(),
        watchTodayReportsUseCase: gh<_i545.WatchTodayReportsUseCase>(),
        getStationHistoryUseCase: gh<_i545.GetStationHistoryUseCase>(),
        getHistoryReportsUseCase: gh<_i545.GetHistoryReportsUseCase>(),
        submitFieldReportUseCase: gh<_i545.SubmitFieldReportUseCase>(),
        confirmFieldReportUseCase: gh<_i545.ConfirmFieldReportUseCase>(),
        getUserConfirmedReportIdsUseCase:
            gh<_i545.GetUserConfirmedReportIdsUseCase>(),
        getFavoriteStationIdsUseCase: gh<_i545.GetFavoriteStationIdsUseCase>(),
        toggleFavoriteStationUseCase: gh<_i545.ToggleFavoriteStationUseCase>(),
      ),
    );
    return this;
  }
}

class _$CoreModule extends _i215.CoreModule {}
