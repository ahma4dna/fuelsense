import 'package:bloc/bloc.dart';
import 'package:fuelsense/features/main/presentaion/state_manege/bloc/main_event.dart';
import 'package:fuelsense/features/main/presentaion/state_manege/bloc/main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainState()) {
    on<ChangeTabEvent>(_chnageTab);
  }

  void _chnageTab(ChangeTabEvent event, Emitter<MainState> emit) {
    emit(state.copyWith(currntIndex: event.selctIndex));
  }
}
