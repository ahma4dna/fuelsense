import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/create_report_params.dart';

abstract class ReportsRemoteDataSource {
  Future<void> submitStationReport(CreateReportParams params);
}

@LazySingleton(as: ReportsRemoteDataSource)
class ReportsRemoteDataSourceImpl implements ReportsRemoteDataSource {
  final SupabaseClient _supabase;
  ReportsRemoteDataSourceImpl(this._supabase);
  @override
  Future<void> submitStationReport(CreateReportParams params) async {
    // 1. Validate authenticated user
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw const AuthException('User is not authenticated');
    }
    // 2. Get user profile
    final user = await _supabase.from('profiles').select('full_name').eq('id', userId).single();
    // 3. Clean optional note
    final cleanNote = params.note?.trim();
    // 4. Generate timestamp
    final now = DateTime.now().toUtc().toIso8601String();
    // 5. Submit report
    await _supabase.from('reports').insert({
      'user_id': userId,
      'station_id': params.stationId,
      'name_user': user['full_name']?.toString() ?? 'مستخدم FuelSense',
      'queue_status': params.queueStatus,
      'note': (cleanNote != null && cleanNote.isNotEmpty) ? cleanNote : null,
      'user_latitude': params.userLatitude,
      'user_longitude': params.userLongitude,
      'distance_to_station': params.distanceToStation,
      'is_within_range': params.isWithinRange,
      'is_verified': true,
      'is_camera_verified': false,
      'confirmations_count': 1,
      'created_at': now,
      'last_confirmed_at': now,
    });
  }
}
