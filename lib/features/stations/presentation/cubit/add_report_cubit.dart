import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/create_report_params.dart';
import '../../domain/use_case/submit_report_use_case.dart';
import 'add_report_state.dart';

@injectable
class AddReportCubit extends Cubit<AddReportState> {
  final SubmitReportUseCase _submitReportUseCase;

  static const double maxAllowedDistanceMeters = 200.0;

  AddReportCubit(this._submitReportUseCase) : super(const AddReportState());

  Future<void> verifyUserLocation({
    required double stationLatitude,
    required double stationLongitude,
  }) async {
    emit(state.copyWith(locationStatus: LocationVerifyStatus.checking));

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(
          state.copyWith(
            locationStatus: LocationVerifyStatus.serviceDisabled,
          ),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(
            state.copyWith(
              locationStatus: LocationVerifyStatus.permissionDenied,
              isPermanentlyDenied: false,
            ),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(
          state.copyWith(
            locationStatus: LocationVerifyStatus.permissionDenied,
            isPermanentlyDenied: true,
          ),
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 12),
        ),
      );

      final distanceInMeters = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        stationLatitude,
        stationLongitude,
      );

      if (distanceInMeters <= maxAllowedDistanceMeters) {
        emit(
          state.copyWith(
            locationStatus: LocationVerifyStatus.inRangeReady,
            userLatitude: position.latitude,
            userLongitude: position.longitude,
            distanceInMeters: distanceInMeters,
          ),
        );
      } else {
        emit(
          state.copyWith(
            locationStatus: LocationVerifyStatus.outOfRange,
            userLatitude: position.latitude,
            userLongitude: position.longitude,
            distanceInMeters: distanceInMeters,
          ),
        );
      }
    } catch (_) {
      emit(
        state.copyWith(
          locationStatus: LocationVerifyStatus.permissionDenied,
          errorMessage: 'تعذر تحديد موقعك الحالي، تأكد من تفعيل الموقع والمحاولة مجدداً.',
        ),
      );
    }
  }

  void selectQueueStatus(String queueStatus) {
    emit(
      state.copyWith(
        selectedQueueStatus: queueStatus,
        submitStatus: ReportSubmitStatus.idle,
      ),
    );
  }

  Future<void> submitReport({
    required int stationId,
    String? note,
  }) async {
    if (state.userLatitude == null || state.userLongitude == null) return;

    emit(state.copyWith(submitStatus: ReportSubmitStatus.submitting));

    final params = CreateReportParams(
      stationId: stationId,
      queueStatus: state.selectedQueueStatus,
      note: note,
      userLatitude: state.userLatitude!,
      userLongitude: state.userLongitude!,
      distanceToStation: state.distanceInMeters ?? 0.0,
      isWithinRange: true,
    );

    final result = await _submitReportUseCase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          submitStatus: ReportSubmitStatus.error,
          errorMessage: "",
        ),
      ),
      (_) => emit(
        state.copyWith(
          submitStatus: ReportSubmitStatus.success,
        ),
      ),
    );
  }
}
