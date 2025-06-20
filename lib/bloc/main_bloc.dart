import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_work_manager/network/get_post_response_model.dart';
import 'package:flutter_work_manager/shared_preferences/shared_preferences.dart';
import 'package:flutter_work_manager/work_manager/work_manager.dart';

import '../util/logger.dart';

part 'main_bloc_event.dart';

part 'main_bloc_state.dart';

typedef MainBlocProvider = BlocProvider<MainBloc>;
typedef MainBlocBuilder = BlocBuilder<MainBloc, MainBlocState>;

class MainBloc extends Bloc<MainBlocEvent, MainBlocState> {
  MainBloc() : super(MainBlocState()) {
    on<MainCountOneOff>((event, emit) {
      Worker.registerOneOffTask();
    });

    on<MainCountPeriodic>((event, emit) {
      Worker.registerPeriodicTask();
    });

    on<MainCountProcessing>((event, emit) {
      Worker.registerProcessingTask();
    });

    on<MainCountChanged>((event, emit) {
      emit(state.copyWith(count: event.num));
    });

    on<MainCountUpdated>((event, emit) async {
      emit(state.copyWith(count: await SharedPreferencesManager.getCount()));
    });

    on<MainPostRetrieved>((event, emit) async {
      Worker.getPost();
    });

    on<MainPostUpdated>((event, emit) async {
      emit(state.copyWith(post: event.post));
    });

    receivePortListener = IsolatePortManager.listen((message) {
      logger.i(message);

      if (message is int) {
        add(MainCountChanged(message));
      }

      if (message is Map<String, dynamic>) {
        if (GetPostResponseModel.isValid(message)) {
          add(MainPostUpdated(GetPostResponseModel.fromJson(message)));
        }
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
