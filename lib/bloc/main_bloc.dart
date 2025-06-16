import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_work_manager/work_manager/work_manager.dart';

part 'main_bloc_event.dart';
part 'main_bloc_state.dart';

typedef MainBlocProvider = BlocProvider<MainBloc>;
typedef MainBlocBuilder = BlocBuilder<MainBloc, MainBlocState>;

class MainBloc extends Bloc<MainBlocEvent, MainBlocState> {
  MainBloc() : super(MainBlocState()) {
    on<MainCountChanged>(
      (event, emit) {
        if (kDebugMode) {
          print('MainCountIncreased: ${state.count + event.num}');
        }

        emit(state.copyWith(count: state.count + event.num));
      },
    );

    receivePortListener = CounterWorkManager.instance.listen((message) {
      if (kDebugMode) {
        print('CounterWorkManager isolate message: $message');
      }

      if (message is int) {
        add(MainCountChanged(message));
      }
    });
  }

  late final StreamSubscription receivePortListener;

  @override
  Future<void> close() {
    receivePortListener.cancel();
    CounterWorkManager.instance.dispose();
    return super.close();
  }
}
