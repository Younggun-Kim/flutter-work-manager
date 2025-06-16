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
    on<MainCountIncreased>((event, emit) {
      CounterWorkManager.instance.increase();
    });

    on<MainCountChanged>(
      (event, emit) {
        emit(state.copyWith(count: event.num));
      },
    );

    on<MainCountUpdated>((event, emit) async {
      emit(state.copyWith(count: await SharedPreferencesManager.getCount()));
    });

    receivePortListener = CounterWorkManager.instance.listen((message) {
      print('Received Message: $message');
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
