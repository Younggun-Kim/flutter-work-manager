import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_work_manager/shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import 'worker_isolate_mixin.dart';

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
    if (kDebugMode) {
      final currentCount = await SharedPreferencesManager.getCount();
      print('Workmanager execute: $taskName current Count: $currentCount');
    }

    switch (taskName) {
      case CounterTaskName.increase:
      case CounterTaskName.increasePeriod:
        SharedPreferencesManager.saveCount(Random().nextInt(5) + 1);
    }

    return Future.value(true);
  });
}

class CounterWorkManager with WorkerIsolateMixin {
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
    if (kDebugMode) {
      print('\nCounterWorkManager periodIncrease\n');
    }

    await Workmanager().registerPeriodicTask(
      CounterTaskName.increasePeriod,
      CounterTaskName.increasePeriod,
    );
  }
}
