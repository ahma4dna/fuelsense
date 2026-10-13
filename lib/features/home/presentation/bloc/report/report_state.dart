import 'package:equatable/equatable.dart';
import 'package:fuelsense/features/home/domain/enums/report_time_line.dart';

enum CheckLocationState {
  lading,
  success,
  error,
}

enum ShothWithCameraState {
  lading,
  success,
  error,
}

enum AiAnalayzState {
  lading,
  success,
  error,
}

enum SendReportState {
  lading,
  success,
  error,
}

class ReportState extends Equatable {
  final ReportTimeLine reportTimeLine;
  const ReportState({
    this.reportTimeLine = ReportTimeLine.location,
  });
  ReportState copyWith({
    ReportTimeLine? reportTimeLine,
  }) {
    return ReportState(
      reportTimeLine: reportTimeLine ?? this.reportTimeLine,
    );
  }

  @override
  List<Object> get props => [reportTimeLine];
}
