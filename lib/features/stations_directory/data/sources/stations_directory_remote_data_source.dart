import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/station_directory_model.dart';

abstract class StationsDirectoryRemoteDataSource {
  Future<List<StationDirectoryModel>> getStationsDirectory();
  Stream<void> watchStationsChanges();
}

@LazySingleton(as: StationsDirectoryRemoteDataSource)
class StationsDirectoryRemoteDataSourceImpl implements StationsDirectoryRemoteDataSource {
  final SupabaseClient _supabase;

  StationsDirectoryRemoteDataSourceImpl(this._supabase);

  @override
  Future<List<StationDirectoryModel>> getStationsDirectory() async {
    // get stations
    final stationsResponse = await _supabase.from('stations').select().order('updated_at', ascending: false);

    // get reports today
    final startOfToday = DateTime.now()
        .copyWith(hour: 0, minute: 0, second: 0, millisecond: 0)
        .toUtc()
        .toIso8601String();

    final reportsResponse = await _supabase
        .from('reports')
        .select('station_id, queue_status, confirmations_count')
        .gte('created_at', startOfToday);

    //
    final Map<int, int> countByStation = {};
    final Map<int, Map<String, int>> queueVotesByStation = {};

    for (final row in (reportsResponse as List<dynamic>)) {
      final stationId = (row['station_id'] as num?)?.toInt();
      if (stationId == null) continue;

      final qStatus = (row['queue_status'] as String?) ?? 'light';
      final confirmations = (row['confirmations_count'] as num?)?.toInt() ?? 1;

      countByStation[stationId] = (countByStation[stationId] ?? 0) + 1;
      queueVotesByStation.putIfAbsent(stationId, () => {});
      queueVotesByStation[stationId]![qStatus] = (queueVotesByStation[stationId]![qStatus] ?? 0) + confirmations;
    }

    return (stationsResponse as List<dynamic>).map((stationJson) {
      final map = stationJson as Map<String, dynamic>;
      final stationId = (map['id'] as num).toInt();
      final reportsCount = countByStation[stationId] ?? 0;

      String? dominantQueue;
      final votes = queueVotesByStation[stationId];
      if (votes != null && votes.isNotEmpty) {
        dominantQueue = votes.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
      }

      return StationDirectoryModel.fromJson(
        map,
        todayReportsCount: reportsCount,
        dominantTodayQueue: dominantQueue,
      );
    }).toList();
  }

  @override
  Stream<void> watchStationsChanges() {
    final controller = StreamController<void>.broadcast();

    final channel = _supabase
        .channel('public:stations_directory_sync')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'stations',
          callback: (_) => controller.add(null),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'reports',
          callback: (_) => controller.add(null),
        )
        .subscribe();

    controller.onCancel = () {
      _supabase.removeChannel(channel);
    };

    return controller.stream;
  }
}
