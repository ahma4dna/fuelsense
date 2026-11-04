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
import 'package:fuelsense/core/preferences/preferences_provider.dart' as _i9;
import 'package:fuelsense/features/auth/data/data_source/auth_remote_data_source.dart'
    as _i529;
import 'package:fuelsense/features/auth/data/repositories/auth_repository_impl.dart'
    as _i535;
import 'package:fuelsense/features/auth/domain/repositories/auth_repository.dart'
    as _i399;
import 'package:fuelsense/features/auth/domain/use_case/auth_use_cases.dart'
    as _i398;
import 'package:fuelsense/features/auth/presentation/bloc/auth_bloc.dart'
    as _i358;
import 'package:fuelsense/features/stations/data/repository/reports_repository_impl.dart'
    as _i826;
import 'package:fuelsense/features/stations/data/repository/stations_repository_imp.dart'
    as _i281;
import 'package:fuelsense/features/stations/data/sources/reports_remote_data_source.dart'
    as _i14;
import 'package:fuelsense/features/stations/domain/repositories/reports_repository.dart'
    as _i521;
import 'package:fuelsense/features/stations/domain/repositories/stations_repository.dart'
    as _i245;
import 'package:fuelsense/features/stations/domain/use_case/stations_use_cases.dart'
    as _i545;
import 'package:fuelsense/features/stations/domain/use_case/submit_report_use_case.dart'
    as _i880;
import 'package:fuelsense/features/stations/presentation/bloc/stations_bloc.dart'
    as _i168;
import 'package:fuelsense/features/stations/presentation/cubit/add_report_cubit.dart'
    as _i500;
import 'package:fuelsense/features/stations_directory/data/repositories/stations_directory_repository_impl.dart'
    as _i506;
import 'package:fuelsense/features/stations_directory/data/sources/stations_directory_remote_data_source.dart'
    as _i490;
import 'package:fuelsense/features/stations_directory/domain/repositories/stations_directory_repository.dart'
    as _i916;
import 'package:fuelsense/features/stations_directory/domain/usecases/get_stations_directory_use_case.dart'
    as _i912;
import 'package:fuelsense/features/stations_directory/presentation/bloc/stations_directory_bloc.dart'
    as _i823;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final coreModule = _$CoreModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => coreModule.sharedPreferences(),
      preResolve: true,
    );
    gh.lazySingleton<_i454.SupabaseClient>(() => coreModule.supabaseClient());
    gh.lazySingleton<_i628.NetworkInfo>(() => coreModule.networkInfo());
    gh.lazySingleton<_i9.PreferencesProvider>(
      () => coreModule.preferencesProvider(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i529.AuthRemoteDataSource>(
      () => _i529.AuthRemoteDataSourceImpl(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i245.StationsRepository>(
      () => _i281.StationsRepositoryImp(
        supabaseClient: gh<_i454.SupabaseClient>(),
        networkInfo: gh<_i628.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i14.ReportsRemoteDataSource>(
      () => _i14.ReportsRemoteDataSourceImpl(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i490.StationsDirectoryRemoteDataSource>(
      () => _i490.StationsDirectoryRemoteDataSourceImpl(
        gh<_i454.SupabaseClient>(),
      ),
    );
    gh.lazySingleton<_i916.StationsDirectoryRepository>(
      () => _i506.StationsDirectoryRepositoryImpl(
        networkInfo: gh<_i628.NetworkInfo>(),
        remoteDataSource: gh<_i490.StationsDirectoryRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i399.AuthRepository>(
      () => _i535.AuthRepositoryImpl(
        networkInfo: gh<_i628.NetworkInfo>(),
        remoteDataSource: gh<_i529.AuthRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i521.ReportsRepository>(
      () => _i826.ReportsRepositoryImpl(
        networkInfo: gh<_i628.NetworkInfo>(),
        remoteDataSource: gh<_i14.ReportsRemoteDataSource>(),
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
    gh.lazySingleton<_i398.SignInWithEmailUseCase>(
      () => _i398.SignInWithEmailUseCase(gh<_i399.AuthRepository>()),
    );
    gh.lazySingleton<_i398.SignUpWithEmailUseCase>(
      () => _i398.SignUpWithEmailUseCase(gh<_i399.AuthRepository>()),
    );
    gh.lazySingleton<_i398.SignInWithGoogleUseCase>(
      () => _i398.SignInWithGoogleUseCase(gh<_i399.AuthRepository>()),
    );
    gh.lazySingleton<_i398.ResetPasswordUseCase>(
      () => _i398.ResetPasswordUseCase(gh<_i399.AuthRepository>()),
    );
    gh.lazySingleton<_i398.GetCurrentUserProfileUseCase>(
      () => _i398.GetCurrentUserProfileUseCase(gh<_i399.AuthRepository>()),
    );
    gh.lazySingleton<_i398.SignOutUseCase>(
      () => _i398.SignOutUseCase(gh<_i399.AuthRepository>()),
    );
    gh.lazySingleton<_i398.UpdatePasswordUseCase>(
      () => _i398.UpdatePasswordUseCase(gh<_i399.AuthRepository>()),
    );
    gh.lazySingleton<_i358.AuthBloc>(
      () => _i358.AuthBloc(
        signInWithEmailUseCase: gh<_i398.SignInWithEmailUseCase>(),
        signUpWithEmailUseCase: gh<_i398.SignUpWithEmailUseCase>(),
        signInWithGoogleUseCase: gh<_i398.SignInWithGoogleUseCase>(),
        resetPasswordUseCase: gh<_i398.ResetPasswordUseCase>(),
        updatePasswordUseCase: gh<_i398.UpdatePasswordUseCase>(),
        getCurrentUserProfileUseCase: gh<_i398.GetCurrentUserProfileUseCase>(),
        signOutUseCase: gh<_i398.SignOutUseCase>(),
        preferencesProvider: gh<_i9.PreferencesProvider>(),
      ),
    );
    gh.lazySingleton<_i880.SubmitReportUseCase>(
      () => _i880.SubmitReportUseCase(gh<_i521.ReportsRepository>()),
    );
    gh.factory<_i500.AddReportCubit>(
      () => _i500.AddReportCubit(gh<_i880.SubmitReportUseCase>()),
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
    gh.lazySingleton<_i912.GetStationsDirectoryUseCase>(
      () => _i912.GetStationsDirectoryUseCase(
        gh<_i916.StationsDirectoryRepository>(),
      ),
    );
    gh.factory<_i823.StationsDirectoryBloc>(
      () =>
          _i823.StationsDirectoryBloc(gh<_i912.GetStationsDirectoryUseCase>()),
    );
    return this;
  }
}

class _$CoreModule extends _i215.CoreModule {}
