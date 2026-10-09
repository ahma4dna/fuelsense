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
import 'package:fuelsense/features/home/data/repositories/station_repository_imp.dart'
    as _i665;
import 'package:fuelsense/features/home/domain/repositories/station_repository.dart'
    as _i497;
import 'package:fuelsense/features/home/domain/usecases/get_nearby_stations.dart'
    as _i77;
import 'package:fuelsense/features/home/domain/usecases/get_station_by_id.dart'
    as _i1009;
import 'package:fuelsense/features/home/domain/usecases/get_station_reports.dart'
    as _i334;
import 'package:fuelsense/features/home/domain/usecases/get_station_reviews.dart'
    as _i1045;
import 'package:fuelsense/features/home/domain/usecases/is_within_range.dart'
    as _i804;
import 'package:fuelsense/features/home/domain/usecases/search_stations.dart'
    as _i922;
import 'package:fuelsense/features/home/domain/usecases/submit_report.dart'
    as _i583;
import 'package:fuelsense/features/home/domain/usecases/submit_review.dart'
    as _i152;
import 'package:fuelsense/features/home/domain/usecases/watch_stations.dart'
    as _i603;
import 'package:fuelsense/features/home/presentation/bloc/report/report_bloc.dart'
    as _i1043;
import 'package:fuelsense/features/home/presentation/bloc/station/station_bloc.dart'
    as _i226;
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
    gh.factory<_i1043.ReportBloc>(() => _i1043.ReportBloc());
    gh.lazySingleton<_i454.SupabaseClient>(() => coreModule.supabaseClient());
    gh.lazySingleton<_i628.NetworkInfo>(() => coreModule.networkInfo());
    gh.lazySingleton<_i497.StationRepository>(
      () => _i665.StationRepositoryImpl(
        gh<_i454.SupabaseClient>(),
        gh<_i628.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i77.GetNearbyStations>(
      () => _i77.GetNearbyStations(gh<_i497.StationRepository>()),
    );
    gh.lazySingleton<_i1009.GetStationById>(
      () => _i1009.GetStationById(gh<_i497.StationRepository>()),
    );
    gh.lazySingleton<_i334.GetStationReports>(
      () => _i334.GetStationReports(gh<_i497.StationRepository>()),
    );
    gh.lazySingleton<_i1045.GetStationReviews>(
      () => _i1045.GetStationReviews(gh<_i497.StationRepository>()),
    );
    gh.lazySingleton<_i804.IsWithinRange>(
      () => _i804.IsWithinRange(gh<_i497.StationRepository>()),
    );
    gh.lazySingleton<_i922.SearchStations>(
      () => _i922.SearchStations(gh<_i497.StationRepository>()),
    );
    gh.lazySingleton<_i583.SubmitReport>(
      () => _i583.SubmitReport(gh<_i497.StationRepository>()),
    );
    gh.lazySingleton<_i152.SubmitReview>(
      () => _i152.SubmitReview(gh<_i497.StationRepository>()),
    );
    gh.lazySingleton<_i603.WatchStations>(
      () => _i603.WatchStations(gh<_i497.StationRepository>()),
    );
    gh.lazySingleton<_i226.StationBloc>(
      () => _i226.StationBloc(
        getNearbyStations: gh<_i77.GetNearbyStations>(),
        watchStations: gh<_i603.WatchStations>(),
        searchStations: gh<_i922.SearchStations>(),
        getStationById: gh<_i1009.GetStationById>(),
        getStationReports: gh<_i334.GetStationReports>(),
        submitReport: gh<_i583.SubmitReport>(),
        getStationReviews: gh<_i1045.GetStationReviews>(),
        submitReview: gh<_i152.SubmitReview>(),
      ),
    );
    return this;
  }
}

class _$CoreModule extends _i215.CoreModule {}
