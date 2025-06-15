import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'main_bloc_event.dart';
part 'main_bloc_state.dart';

typedef MainBlocProvider = BlocProvider<MainBloc>;
typedef MainBlocBuilder = BlocBuilder<MainBloc, MainBlocState>;

class MainBloc extends Bloc<MainBlocEvent, MainBlocState> {
  MainBloc() : super(MainBlocState()) {
    on<MainCountIncreased>(
      (event, emit) {
        print('MainCountIncreased: ${state.count + 1}');

        emit(state.copyWith(count: state.count + 1));
      },
    );
    on<MainCountDecreased>(
      (event, emit) {
        print('MainCountIncreased: ${state.count - 1}');

        emit(state.copyWith(count: state.count - 1));
      },
    );

    final receivePort = ReceivePort();

    IsolateNameServer.registerPortWithName(
      receivePort.sendPort,
      'counter_work_manager',
    );

    receivePort.listen((message) {
      print('CounterWorkManager isolate message: ${message}');

      if (message == 'increase') {
        add(MainCountIncreased());
      } else if (message == 'decrease') {
        add(MainCountDecreased());
      }
    });
  }
}
