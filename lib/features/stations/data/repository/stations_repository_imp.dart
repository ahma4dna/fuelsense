import 'package:fpdart/fpdart.dart';
import 'package:fuelsense/features/stations/data/models/field_report/field_report_model.dart';
import 'package:fuelsense/features/stations/data/models/station/station_model.dart';
import 'package:fuelsense/features/stations/data/models/station_history/station_history_model.dart';
import 'package:fuelsense/features/stations/domain/repositories/stations_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/data/network/safe_api_call.dart';
import '../../../../core/data/network/safe_stream_call.dart';
import '../../../../core/data/network_info/network_info.dart';
import '../../../../core/domain/models/failure.dart';
import '../../domain/entities/field_report_entity.dart';
import '../../domain/entities/station_entity.dart';
import '../../domain/entities/station_history_entity.dart';
import '../../domain/enums/station_enums.dart';
import '../../domain/extensions/station_extensions.dart';
import '../mapper/stations_mapper.dart';

@LazySingleton(as: StationsRepository)
class StationsRepositoryImp implements StationsRepository {
  final SupabaseClient _supabase;
  final NetworkInfo networkInfo;

  StationsRepositoryImp({
    required SupabaseClient supabaseClient,
    required this.networkInfo,
  }) : _supabase = supabaseClient;

  @override
  Stream<Either<Failure, List<StationEntity>>> watchStations() async* {
    yield* safeStreamCall(
      networkInfo: networkInfo,
      apiCall: () {
        return _supabase
            .from('stations')
            .stream(primaryKey: ['id'])
            .eq('is_active', true)
            .order('last_updated', ascending: false)
            .map((data) => data.map((e) => StationModel.fromJson(e).toEntity()).toList());
      },
    );
  }

  @override
  Stream<Either<Failure, List<FieldReportEntity>>> watchTodayStationReports(
    int stationId,
  ) async* {
    yield* safeStreamCall(
      networkInfo: networkInfo,
      apiCall: () {
        final now = DateTime.now();
        final startOfToday = DateTime(now.year, now.month, now.day);

        return _supabase
            .from('reports')
            .stream(primaryKey: ['id'])
            .eq('station_id', stationId)
            .order('created_at', ascending: false)
            .map((data) {
              return data
                  .map((e) => FieldReportModel.fromJson(e).toEntity())
                  .where((report) => report.createdAt.isAfter(startOfToday))
                  .toList();
            });
      },
    );
  }

  @override
  Future<Either<Failure, List<StationHistoryEntity>>> getStationHistory(
    int stationId,
  ) async {
    return safeApiCall(
      networkInfo: networkInfo,
      apiCall: () async {
        final response = await _supabase
            .from('station_status_history')
            .select()
            .eq('station_id', stationId)
            .order('created_at', ascending: false)
            .limit(30);

        return (response as List).map((e) => StationHistoryModel.fromJson(e).toEntity()).toList();
      },
    );
  }

  @override
  Future<Either<Failure, List<FieldReportEntity>>> getReportsByHistoryId(
    int historyId,
  ) async {
    return safeApiCall(
      networkInfo: networkInfo,
      apiCall: () async {
        final response = await _supabase
            .from('reports')
            .select()
            .eq('history_id', historyId)
            .order('created_at', ascending: false);

        return (response as List).map((e) => FieldReportModel.fromJson(e).toEntity()).toList();
      },
    );
  }

  @override
  Future<Either<Failure, void>> submitFieldReport(
    SubmitFieldReportParams params,
  ) async {
    return safeApiCall(
      networkInfo: networkInfo,
      apiCall: () async {
        final userId = _supabase.auth.currentUser!.id;
        final trimmedNote = params.note?.trim();

        await _supabase.from('reports').insert({
          'user_id': userId,
          'station_id': params.stationId,
          'queue_status': params.queueStatus.dbValue,
          'note': (trimmedNote != null && trimmedNote.isNotEmpty)
              ? (trimmedNote.length > 120 ? trimmedNote.substring(0, 120) : trimmedNote)
              : null,
          'user_latitude': params.userLatitude,
          'user_longitude': params.userLongitude,
          'distance_to_station': params.distanceToStation,
          'is_within_range': params.distanceToStation <= 200.0,
          'is_verified': true,
          'is_camera_verified': params.isCameraVerified,
          'ai_confidence': params.aiConfidence,
          'ai_inference_ms': params.aiInferenceMs,
        });

        if (params.isCameraVerified && params.queueStatus != QueueLevel.stopped) {
          final twoHoursAgo = DateTime.now().subtract(const Duration(hours: 2)).toIso8601String();

          final recentNotif = await _supabase
              .from('notifications')
              .select('id')
              .eq('station_id', params.stationId)
              .eq('notification_type', 'field_camera')
              .gte('created_at', twoHoursAgo)
              .maybeSingle();

          if (recentNotif == null) {
            await _supabase.from('notifications').insert({
              'station_id': params.stationId,
              'city': params.stationCity,
              'notification_type': 'field_camera',
              'title': 'توثيق ميداني',
              'body': 'مستخدمون في الموقع أكدوا بدء العمل في ${params.stationName} - ${params.stationCity}.',
            });
          }
        }
      },
    );
  }

  @override
  Future<Either<Failure, void>> confirmFieldReport(
    ConfirmFieldReportParams params,
  ) async {
    return safeApiCall(
      networkInfo: networkInfo,
      apiCall: () async {
        final userId = _supabase.auth.currentUser!.id;

        await _supabase.from('report_confirmations').insert({
          'report_id': params.reportId,
          'user_id': userId,
          'user_latitude': params.userLatitude,
          'user_longitude': params.userLongitude,
          'distance_to_station': params.distanceToStation,
        });
      },
    );
  }

  @override
  Future<Either<Failure, List<int>>> getUserConfirmedReportIds(
    int stationId,
  ) async {
    return safeApiCall(
      networkInfo: networkInfo,
      apiCall: () async {
        final userId = _supabase.auth.currentUser?.id;
        if (userId == null) return <int>[];

        final response = await _supabase
            .from('report_confirmations')
            .select('report_id, reports!inner(station_id)')
            .eq('user_id', userId)
            .eq('reports.station_id', stationId);

        return (response as List).map((e) => (e['report_id'] as num).toInt()).toList();
      },
    );
  }

  @override
  Future<Either<Failure, List<int>>> getFavoriteStationIds() async {
    return safeApiCall(
      networkInfo: networkInfo,
      apiCall: () async {
        final userId = _supabase.auth.currentUser?.id;
        if (userId == null) return <int>[];

        final response = await _supabase.from('favorites').select('station_id').eq('user_id', userId);

        return (response as List).map((e) => (e['station_id'] as num).toInt()).toList();
      },
    );
  }

  @override
  Future<Either<Failure, bool>> toggleFavoriteStation(int stationId) async {
    return safeApiCall(
      networkInfo: networkInfo,
      apiCall: () async {
        final userId = _supabase.auth.currentUser!.id;

        final existing = await _supabase
            .from('favorites')
            .select('id')
            .eq('user_id', userId)
            .eq('station_id', stationId)
            .maybeSingle();

        if (existing != null) {
          await _supabase.from('favorites').delete().eq('id', existing['id']);
          return false; // أزيلت من المفضلة
        } else {
          await _supabase.from('favorites').insert({
            'user_id': userId,
            'station_id': stationId,
            'notify_on_open': true,
          });
          return true; // أضيفت للمفضلة
        }
      },
    );
  }
}
