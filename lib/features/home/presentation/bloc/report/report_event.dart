import 'package:equatable/equatable.dart';
import 'package:fuelsense/features/home/domain/enums/report_time_line.dart';

sealed class ReportEvent extends Equatable {
  const ReportEvent();
}

final class UpdateTimeLine extends ReportEvent {
  final ReportTimeLine reportTimeLine;

  const new({required this.reportTimeLine});
  @override
  List<Object?> get props => [reportTimeLine];
}
