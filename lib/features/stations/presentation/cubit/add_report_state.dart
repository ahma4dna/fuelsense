import 'package:equatable/equatable.dart';

enum LocationVerifyStatus {
  checking,
  serviceDisabled,
  permissionDenied,
  outOfRange,
  inRangeReady,
}

enum ReportSubmitStatus {
  idle,
  submitting,
  success,
  error,
}

class AddReportState extends Equatable {
  final LocationVerifyStatus locationStatus;
  final ReportSubmitStatus submitStatus;
  final double? userLatitude;
  final double? userLongitude;
  final double? distanceInMeters;
  final String selectedQueueStatus;
  final String? errorMessage;
  final bool isPermanentlyDenied;

  const AddReportState({
    this.locationStatus = LocationVerifyStatus.checking,
    this.submitStatus = ReportSubmitStatus.idle,
    this.userLatitude,
    this.userLongitude,
    this.distanceInMeters,
    this.selectedQueueStatus = 'light',
    this.errorMessage,
    this.isPermanentlyDenied = false,
  });

  AddReportState copyWith({
    LocationVerifyStatus? locationStatus,
    ReportSubmitStatus? submitStatus,
    double? userLatitude,
    double? userLongitude,
    double? distanceInMeters,
    String? selectedQueueStatus,
    String? errorMessage,
    bool? isPermanentlyDenied,
  }) {
    return AddReportState(
      locationStatus: locationStatus ?? this.locationStatus,
      submitStatus: submitStatus ?? this.submitStatus,
      userLatitude: userLatitude ?? this.userLatitude,
      userLongitude: userLongitude ?? this.userLongitude,
      distanceInMeters: distanceInMeters ?? this.distanceInMeters,
      selectedQueueStatus: selectedQueueStatus ?? this.selectedQueueStatus,
      errorMessage: errorMessage,
      isPermanentlyDenied: isPermanentlyDenied ?? this.isPermanentlyDenied,
    );
  }

  @override
  List<Object?> get props => [
    locationStatus,
    submitStatus,
    userLatitude,
    userLongitude,
    distanceInMeters,
    selectedQueueStatus,
    errorMessage,
    isPermanentlyDenied,
  ];
}
