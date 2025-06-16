import 'dart:async';
import 'dart:isolate';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_work_manager/shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import 'isolate_port_mixin.dart';

abstract final class CounterTaskName {
  static const String increase = 'increase';
  static const String increasePeriod = 'increasePeriod';
}

@pragma('vm:entry-point')
void counterWorkManagerDispatcher() {
  Workmanager().executeTask((
    String taskName,
    Map<String, dynamic>? inputData,
  ) async {
    final currentCount = await SharedPreferencesManager.getCount();

    switch (taskName) {
      case CounterTaskName.increase:
      case CounterTaskName.increasePeriod:
        final newCount = currentCount + Random().nextInt(5);

        /// SharedPreferences에 저장
        SharedPreferencesManager.saveCount(newCount);

        /// Main Isolate의 MainBloc에 메시지 전달
        SendPort? sendPort = CounterWorkManager.instance.getSendPort();

        sendPort?.send(newCount);

      case Workmanager.iOSBackgroundTask:
        print('Workmanager.iOSBackgroundTask: ${inputData}');
    }

    return Future.value(true);
  });
}

class CounterWorkManager with IsolatePortMixin {
  CounterWorkManager._internal();

  static final CounterWorkManager instance = CounterWorkManager._internal();

  @override
  String get isolateNameServerName => 'counter_work_manager_name_server';

  @override
  void init() async {
    super.init();
    await Workmanager().initialize(
      counterWorkManagerDispatcher,
      isInDebugMode: kDebugMode,
    );

    await periodIncrease();
  }

  @override
  void dispose() {
    Workmanager().cancelByUniqueName(CounterTaskName.increase);

    super.dispose();
  }

  void increase() {
    Workmanager().registerOneOffTask(
      CounterTaskName.increase,
      CounterTaskName.increase,
      existingWorkPolicy: ExistingWorkPolicy.append,
    );
  }

  /// Andorid - 15분 주기
  /// iOS - 30분 주기(?)
  Future<void> periodIncrease() async {
    /// 등록된 스케쥴이면 빠른 종료
    if (await Workmanager().isScheduledByUniqueName(
      CounterTaskName.increasePeriod,
    )) {
      return;
    }

    await Workmanager().registerPeriodicTask(
      CounterTaskName.increasePeriod,
      CounterTaskName.increasePeriod,
    );
  }
}
