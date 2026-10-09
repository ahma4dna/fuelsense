import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuelsense/features/home/presentation/bloc/report/report_event.dart';
import 'package:fuelsense/features/home/presentation/bloc/report/report_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class ReportBloc extends Bloc<ReportEvent, ReportState> {
  ReportBloc() : super(ReportState()) {
    // on<ReportEvent>((event, emit) {});
    on<UpdateTimeLine>(_updateTimeLine);
  }

  FutureOr<void> _updateTimeLine(UpdateTimeLine event, Emitter<ReportState> emit) {
    emit(state.copyWith(reportTimeLine: event.reportTimeLine));
  }
}
