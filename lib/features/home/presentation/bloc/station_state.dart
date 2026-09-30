import 'package:equatable/equatable.dart';
import 'package:fuelsense/core/domain/models/failure.dart';
import 'package:fuelsense/core/presentation/state_renderer/state_renderer_type.dart';
import 'package:fuelsense/features/home/data/models/report_model.dart';
import 'package:fuelsense/features/home/data/models/review_model.dart';
import 'package:fuelsense/features/home/data/models/station_model.dart';

enum StationStatus {
  initial,
  loading,
  success,
  failure,
}

enum ReportStatus {
  initial,
  loading,
  success,
  failure,
}

enum ReviewStatus {
  initial,
  loading,
  success,
  failure,
}

class StationState extends Equatable {
  final StationStatus stationStatus;
  final List<StationModel> stations;
  final StationModel? selectedStation;

  final ReportStatus reportStatus;
  final List<ReportModel> reports;
  final List<ReportModel> myReports;

  final ReviewStatus reviewStatus;
  final List<ReviewModel> reviews;

  final Failure? failure;
  //global state
  final StateRendererType stateRendererType;

  const StationState({
    this.stationStatus = StationStatus.initial,
    this.stateRendererType = StateRendererType.contentState,
    this.stations = const [],
    this.selectedStation,
    this.reportStatus = ReportStatus.initial,
    this.reports = const [],
    this.myReports = const [],
    this.reviewStatus = ReviewStatus.initial,
    this.reviews = const [],
    this.failure,
  });

  StationState copyWith({
    StationStatus? stationStatus,
    List<StationModel>? stations,
    StationModel? selectedStation,
    ReportStatus? reportStatus,
    List<ReportModel>? reports,
    List<ReportModel>? myReports,
    ReviewStatus? reviewStatus,
    List<ReviewModel>? reviews,
    StateRendererType? stateRendererType,
    Failure? failure,
  }) {
    return StationState(
      stationStatus: stationStatus ?? this.stationStatus,
      stations: stations ?? this.stations,
      selectedStation: selectedStation ?? this.selectedStation,
      reportStatus: reportStatus ?? this.reportStatus,
      reports: reports ?? this.reports,
      myReports: myReports ?? this.myReports,
      reviewStatus: reviewStatus ?? this.reviewStatus,
      reviews: reviews ?? this.reviews,
      stateRendererType: stateRendererType ?? this.stateRendererType,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [
    stationStatus,
    stations,
    selectedStation,
    reportStatus,
    reports,
    myReports,
    reviewStatus,
    reviews,
    failure,
    stateRendererType,
  ];
}
