import 'dart:io';
import 'dart:math';

import 'package:fpdart/fpdart.dart';
import 'package:fuelsense/core/data/network/safe_api_call.dart';
import 'package:fuelsense/core/data/network/safe_stream_call.dart';
import 'package:fuelsense/core/domain/models/failure.dart';
import 'package:fuelsense/core/data/network_info/network_info.dart';
import 'package:fuelsense/features/home/domain/repositories/station_repository.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/station_model.dart';
import '../models/report_model.dart';
import '../models/review_model.dart';

class StationRepositoryImpl implements StationRepository {
  final SupabaseClient _client;
  final NetworkInfo _networkInfo;

  StationRepositoryImpl(this._client, this._networkInfo);

  String get _userId => _client.auth.currentUser!.id;
  //stations
  @override
  Future<Either<Failure, List<StationModel>>> getNearbyStations({
    required double latitude,
    required double longitude,
    double radiusKm = 20,
  }) async {
    return safeApiCall(
      networkInfo: _networkInfo,
      apiCall: () async {
        final response = await _client.rpc(
          'get_nearby_stations',
          params: {
            'user_lat': latitude,
            'user_lng': longitude,
            'radius_km': radiusKm,
          },
        );

        return (response as List).map((json) => StationModel.fromJson(json as Map<String, dynamic>)).toList();
      },
    );
  }

  @override
  Stream<Either<Failure, List<StationModel>>> watchStations() {
    return safeStreamCall(
      networkInfo: _networkInfo,
      apiCall: () {
        return _client
            .from('stations')
            .stream(primaryKey: ['id'])
            .eq('is_active', true)
            .map((data) => data.map((json) => StationModel.fromJson(json)).toList());
      },
    );
  }

  @override
  Future<Either<Failure, List<StationModel>>> searchStations(String query) async {
    return safeApiCall(
      networkInfo: _networkInfo,
      apiCall: () async {
        final trimmed = query.trim();
        if (trimmed.isEmpty) return <StationModel>[];

        final response = await _client
            .from('stations')
            .select()
            .or('name.ilike.%$trimmed%,address.ilike.%$trimmed%,name_en.ilike.%$trimmed%')
            .eq('is_active', true)
            .order('name')
            .limit(20);

        return (response as List).map((json) => StationModel.fromJson(json as Map<String, dynamic>)).toList();
      },
    );
  }

  @override
  Future<Either<Failure, StationModel>> getStationById(int stationId) async {
    return safeApiCall(
      networkInfo: _networkInfo,
      apiCall: () async {
        final response = await _client.from('stations').select().eq('id', stationId).single();

        return StationModel.fromJson(response);
      },
    );
  }

  //reports

  @override
  Future<Either<Failure, List<ReportModel>>> getStationReports(
    int stationId, {
    int limit = 10,
  }) async {
    return safeApiCall(
      networkInfo: _networkInfo,
      apiCall: () async {
        final response = await _client
            .from('reports')
            .select('''
              *,
              profiles!user_id (
                full_name,
                trust_level,
                avatar_url
              )
            ''')
            .eq('station_id', stationId)
            .eq('is_within_range', true)
            .order('created_at', ascending: false)
            .limit(limit);

        return (response as List).map((json) => ReportModel.fromJson(json as Map<String, dynamic>)).toList();
      },
    );
  }

  @override
  Future<Either<Failure, ReportModel>> submitReport({
    required int stationId,
    required String status,
    required double userLatitude,
    required double userLongitude,
    int? carCount,
    String? note,
    File? photo,
  }) async {
    return safeApiCall(
      networkInfo: _networkInfo,
      apiCall: () async {
        // 1. رفع الصورة إن وجدت
        String? photoUrl;
        if (photo != null) {
          final uploadResult = await uploadReportPhoto(photo);
          photoUrl = uploadResult.fold(
            (failure) => null,
            (url) => url,
          );
        }

        // 2. إدخال البلاغ
        final response = await _client
            .from('reports')
            .insert({
              'user_id': _userId,
              'station_id': stationId,
              'status': status,
              'car_count': carCount,
              'photo_url': photoUrl,
              'note': note,
              'user_latitude': userLatitude,
              'user_longitude': userLongitude,
            })
            .select()
            .single();

        await _recalculateProbability(stationId);

        return ReportModel.fromJson(response);
      },
    );
  }

  // ═══════════════════════════════════════════
  //  التقييمات
  // ═══════════════════════════════════════════

  @override
  Future<Either<Failure, List<ReviewModel>>> getStationReviews(
    int stationId, {
    int limit = 10,
  }) async {
    return safeApiCall(
      networkInfo: _networkInfo,
      apiCall: () async {
        final response = await _client
            .from('reviews')
            .select('''
              *,
              profiles!user_id (
                full_name,
                trust_level,
                avatar_url
              )
            ''')
            .eq('station_id', stationId)
            .order('created_at', ascending: false)
            .limit(limit);

        return (response as List).map((json) => ReviewModel.fromJson(json as Map<String, dynamic>)).toList();
      },
    );
  }

  @override
  Future<Either<Failure, ReviewModel>> submitReview({
    required int stationId,
    required int rating,
    required String actualStatus,
    required bool predictionWasCorrect,
    String? comment,
    double? predictionAtVisit,
  }) async {
    return safeApiCall(
      networkInfo: _networkInfo,
      apiCall: () async {
        final response = await _client
            .from('reviews')
            .insert({
              'user_id': _userId,
              'station_id': stationId,
              'rating': rating,
              'actual_status': actualStatus,
              'prediction_was_correct': predictionWasCorrect,
              'comment': comment,
              'prediction_at_visit': predictionAtVisit,
            })
            .select()
            .single();

        await _recalculateProbability(stationId);
        await _updateUserTrust(predictionWasCorrect);

        return ReviewModel.fromJson(response);
      },
    );
  }

  //upload photo

  @override
  Future<Either<Failure, String>> uploadReportPhoto(File photo) async {
    return safeApiCall(
      networkInfo: _networkInfo,
      apiCall: () async {
        final ext = photo.path.split('.').last;
        final fileName = '${_userId}_${DateTime.now().millisecondsSinceEpoch}.$ext';
        final storagePath = 'reports/$fileName';

        await _client.storage
            .from('report-photos')
            .upload(
              storagePath,
              photo,
              fileOptions: const FileOptions(upsert: true),
            );

        return _client.storage.from('report-photos').getPublicUrl(storagePath);
      },
    );
  }

  // ═══════════════════════════════════════════
  //  الحسابات الجغرافية (محلية - بدون سيرفر)
  // ═══════════════════════════════════════════

  @override
  bool isWithinRange({
    required double userLat,
    required double userLng,
    required double stationLat,
    required double stationLng,
    double maxDistanceMeters = 200,
  }) {
    return calculateDistance(
          lat1: userLat,
          lng1: userLng,
          lat2: stationLat,
          lng2: stationLng,
        ) <=
        maxDistanceMeters;
  }

  @override
  double calculateDistance({
    required double lat1,
    required double lng1,
    required double lat2,
    required double lng2,
  }) {
    const earthRadius = 6371000.0;
    final dLat = _toRadians(lat2 - lat1);
    final dLng = _toRadians(lng2 - lng1);
    final a =
        sin(dLat / 2) * sin(dLat / 2) + cos(_toRadians(lat1)) * cos(_toRadians(lat2)) * sin(dLng / 2) * sin(dLng / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degree) => degree * pi / 180;

  //function help

  Future<void> _recalculateProbability(int stationId) async {
    await _client.rpc(
      'recalculate_probability',
      params: {
        'p_station_id': stationId,
      },
    );
  }

  Future<void> _updateUserTrust(bool predictionWasCorrect) async {
    final profile = await _client.from('profiles').select('trust_score, correct_reports').eq('id', _userId).single();

    double currentScore = (profile['trust_score'] as num).toDouble();
    int correctReports = profile['correct_reports'] as int;

    if (predictionWasCorrect) {
      currentScore = (currentScore + 0.03).clamp(0.0, 1.0);
      correctReports++;
    } else {
      currentScore = (currentScore - 0.05).clamp(0.0, 1.0);
    }

    await _client
        .from('profiles')
        .update({
          'trust_score': currentScore,
          'correct_reports': correctReports,
        })
        .eq('id', _userId);
  }
}
