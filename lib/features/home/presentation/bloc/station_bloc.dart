import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fuelsense/core/data/error_handling/error_handling.dart';
import 'package:fuelsense/core/domain/models/failure.dart';
import 'package:fuelsense/features/home/data/models/station_model.dart';
import 'package:fuelsense/features/home/domain/usecases/get_nearby_stations.dart';
import 'package:fuelsense/features/home/domain/usecases/get_station_by_id.dart';
import 'package:fuelsense/features/home/domain/usecases/get_station_reports.dart';
import 'package:fuelsense/features/home/domain/usecases/get_station_reviews.dart';
import 'package:fuelsense/features/home/domain/usecases/search_stations.dart';
import 'package:fuelsense/features/home/domain/usecases/submit_report.dart';
import 'package:fuelsense/features/home/domain/usecases/submit_review.dart';
import 'package:fuelsense/features/home/domain/usecases/watch_stations.dart';
import 'package:injectable/injectable.dart';

import 'station_event.dart';
import 'station_state.dart';

@lazySingleton
class StationBloc extends Bloc<StationEvent, StationState> {
  final GetNearbyStations getNearbyStations;
  final WatchStations watchStations;
  final SearchStations searchStations;
  final GetStationById getStationById;

  final GetStationReports getStationReports;
  final SubmitReport submitReport;

  final GetStationReviews getStationReviews;
  final SubmitReview submitReview;

  StreamSubscription<Either<Failure, List<StationModel>>>? _stationsSubscription;

  StationBloc({
    required this.getNearbyStations,
    required this.watchStations,
    required this.searchStations,
    required this.getStationById,
    required this.getStationReports,
    required this.submitReport,
    required this.getStationReviews,
    required this.submitReview,
  }) : super(const StationState()) {
    on<GetNearbyStationsEvent>(_onGetNearbyStations);
    on<WatchStationsEvent>(_onWatchStations);
    on<SearchStationsEvent>(_onSearchStations);
    on<GetStationByIdEvent>(_onGetStationById);

    on<GetStationReportsEvent>(_onGetStationReports);
    on<SubmitReportEvent>(_onSubmitReport);

    on<GetStationReviewsEvent>(_onGetStationReviews);
    on<SubmitReviewEvent>(_onSubmitReview);
  }

  // Stations

  Future<void> _onGetNearbyStations(
    GetNearbyStationsEvent event,
    Emitter<StationState> emit,
  ) async {
    emit(
      state.copyWith(
        stationStatus: StationStatus.loading,
        failure: null,
      ),
    );

    final result = await getNearbyStations(
      latitude: event.latitude,
      longitude: event.longitude,
      radiusKm: event.radiusKm,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            stationStatus: StationStatus.failure,
            failure: failure,
          ),
        );
      },
      (stations) {
        emit(
          state.copyWith(
            stationStatus: StationStatus.success,
            stations: stations,
            failure: null,
          ),
        );
      },
    );
  }

  Future<void> _onWatchStations(
    WatchStationsEvent event,
    Emitter<StationState> emit,
  ) async {
    await _stationsSubscription?.cancel();

    emit(
      state.copyWith(
        stationStatus: StationStatus.loading,
        failure: null,
      ),
    );

    _stationsSubscription = watchStations().listen(
      (result) {
        result.fold(
          (failure) {
            add(
              _StationsStreamFailureEvent(failure),
            );
          },
          (stations) {
            add(
              _StationsStreamSuccessEvent(stations),
            );
          },
        );
      },
      onError: (error, stackTrace) {
        add(
          _StationsStreamFailureEvent(ErrorHandling.handel(error).failure),
        );
      },
    );
  }

  Future<void> _onSearchStations(
    SearchStationsEvent event,
    Emitter<StationState> emit,
  ) async {
    final query = event.query.trim();

    if (query.isEmpty) {
      emit(
        state.copyWith(
          stationStatus: StationStatus.success,
          stations: const [],
          failure: null,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        stationStatus: StationStatus.loading,
        failure: null,
      ),
    );

    final result = await searchStations(query);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            stationStatus: StationStatus.failure,
            failure: failure,
          ),
        );
      },
      (stations) {
        emit(
          state.copyWith(
            stationStatus: StationStatus.success,
            stations: stations,
            failure: null,
          ),
        );
      },
    );
  }

  Future<void> _onGetStationById(
    GetStationByIdEvent event,
    Emitter<StationState> emit,
  ) async {
    emit(
      state.copyWith(
        stationStatus: StationStatus.loading,
        failure: null,
      ),
    );

    final result = await getStationById(event.stationId);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            stationStatus: StationStatus.failure,
            failure: failure,
          ),
        );
      },
      (station) {
        emit(
          state.copyWith(
            stationStatus: StationStatus.success,
            selectedStation: station,
            failure: null,
          ),
        );
      },
    );
  }

  // Reports

  Future<void> _onGetStationReports(
    GetStationReportsEvent event,
    Emitter<StationState> emit,
  ) async {
    emit(
      state.copyWith(
        reportStatus: ReportStatus.loading,
        failure: null,
      ),
    );

    final result = await getStationReports(
      event.stationId,
      limit: event.limit,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            reportStatus: ReportStatus.failure,

            failure: failure,
          ),
        );
      },
      (reports) {
        emit(
          state.copyWith(
            reportStatus: ReportStatus.success,
            reports: reports,
            failure: null,
          ),
        );
      },
    );
  }

  Future<void> _onSubmitReport(
    SubmitReportEvent event,
    Emitter<StationState> emit,
  ) async {
    emit(
      state.copyWith(
        reportStatus: ReportStatus.loading,
        failure: null,
      ),
    );

    final result = await submitReport(
      stationId: event.stationId,
      status: event.status,
      userLatitude: event.userLatitude,
      userLongitude: event.userLongitude,
      carCount: event.carCount,
      note: event.note,
      photo: event.photo,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            reportStatus: ReportStatus.failure,

            failure: failure,
          ),
        );
      },
      (report) {
        final updatedReports = [
          report,
          ...state.reports,
        ];

        emit(
          state.copyWith(
            reportStatus: ReportStatus.success,
            reports: updatedReports,
            failure: null,
          ),
        );
      },
    );
  }

  // Reviews

  Future<void> _onGetStationReviews(
    GetStationReviewsEvent event,
    Emitter<StationState> emit,
  ) async {
    emit(
      state.copyWith(
        reviewStatus: ReviewStatus.loading,
        failure: null,
      ),
    );

    final result = await getStationReviews(
      event.stationId,
      limit: event.limit,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            reviewStatus: ReviewStatus.failure,

            failure: failure,
          ),
        );
      },
      (reviews) {
        emit(
          state.copyWith(
            reviewStatus: ReviewStatus.success,
            reviews: reviews,
            failure: null,
          ),
        );
      },
    );
  }

  Future<void> _onSubmitReview(
    SubmitReviewEvent event,
    Emitter<StationState> emit,
  ) async {
    emit(
      state.copyWith(
        reviewStatus: ReviewStatus.loading,
        failure: null,
      ),
    );

    final result = await submitReview(
      stationId: event.stationId,
      rating: event.rating,
      actualStatus: event.actualStatus,
      predictionWasCorrect: event.predictionWasCorrect,
      comment: event.comment,
      predictionAtVisit: event.predictionAtVisit,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            reviewStatus: ReviewStatus.failure,

            failure: failure,
          ),
        );
      },
      (review) {
        final updatedReviews = [
          review,
          ...state.reviews,
        ];

        emit(
          state.copyWith(
            reviewStatus: ReviewStatus.success,
            reviews: updatedReviews,
            failure: null,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() async {
    await _stationsSubscription?.cancel();
    return super.close();
  }
}

// Internal stream events

class _StationsStreamSuccessEvent extends StationEvent {
  final List<StationModel> stations;

  const _StationsStreamSuccessEvent(this.stations);

  @override
  List<Object?> get props => [stations];
}

class _StationsStreamFailureEvent extends StationEvent {
  final Failure failure;

  const _StationsStreamFailureEvent(this.failure);

  @override
  List<Object?> get props => [failure];
}
