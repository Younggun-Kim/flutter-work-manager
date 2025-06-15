import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';

abstract final class TaskName {
  static const String increase = 'increase';
  static const String decrease = 'decrease';
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask(
    (
      String taskName,
      Map<String, dynamic>? inputData,
    ) async {
      switch (taskName) {
        case TaskName.increase:
          final port = IsolateNameServer.lookupPortByName(
            'work_manager',
          );

          port?.send('increase');

          break;
        case TaskName.decrease:
          print('decrease: $inputData');
        case Workmanager.iOSBackgroundTask:
          break;
      }

      // Work Result 참고
      return Future.value(true);
    },
  );
}

class Worker {
  static Workmanager get instance => Workmanager();

  static void init() async {
    instance.initialize(callbackDispatcher, isInDebugMode: kDebugMode);
  }

  static void increase() {
    Workmanager().registerOneOffTask(
      TaskName.increase,
      TaskName.increase,
      existingWorkPolicy: ExistingWorkPolicy.append,
    );
  }
}
