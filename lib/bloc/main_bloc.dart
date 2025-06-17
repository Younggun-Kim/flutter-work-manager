import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_work_manager/shared_preferences/shared_preferences.dart';
import 'package:flutter_work_manager/work_manager/work_manager.dart';

part 'main_bloc_event.dart';

part 'main_bloc_state.dart';

typedef MainBlocProvider = BlocProvider<MainBloc>;
typedef MainBlocBuilder = BlocBuilder<MainBloc, MainBlocState>;

class MainBloc extends Bloc<MainBlocEvent, MainBlocState> {
  MainBloc() : super(MainBlocState()) {
    on<MainCountOneOff>((event, emit) {
      Worker.emitOneOff();
    });

    on<MainCountPeriodic>((event, emit) {
      Worker.emitPeriodic();
    });

    on<MainCountProcessing>((event, emit) {
      Worker.emitProcessing();
    });

    on<MainCountChanged>((event, emit) {
      emit(state.copyWith(count: event.num));
    });

    on<MainCountUpdated>((event, emit) async {
      emit(state.copyWith(count: await SharedPreferencesManager.getCount()));
    });

    receivePortListener = IsolatePortManager.listen((message) {
      if (message is int) {
        add(MainCountChanged(message));
      }
    });
  }

  late final StreamSubscription receivePortListener;

  @override
  Future<void> close() {
    receivePortListener.cancel();
    IsolatePortManager.dispose();
    return super.close();
  }
}
