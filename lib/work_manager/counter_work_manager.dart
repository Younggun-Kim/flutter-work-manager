import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';

import 'worker_isolate_mixin.dart';

abstract final class CounterTaskName {
  static const String increase = 'increase';
}

@pragma('vm:entry-point')
void counterWorkManagerDispatcher() {
  Workmanager().executeTask((
    String taskName,
    Map<String, dynamic>? inputData,
  ) async {
    print('Workmanager execute: ${taskName}');

    switch (taskName) {
      case CounterTaskName.increase:
        final sendPort = IsolateNameServer.lookupPortByName(
          CounterWorkManager.instance.isolateNameServerName,
        );

        final sign = Random().nextBool() ? 1 : -1;
        sendPort?.send(Random().nextInt(5) * sign);
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
}
