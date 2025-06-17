import 'dart:isolate';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_work_manager/shared_preferences/shared_preferences_manager.dart';
import 'package:workmanager/workmanager.dart';

import 'isolate_port_manager.dart';
import 'worker_task_type.dart';

@pragma('vm:entry-point')
void workerDispatcher() {
  Workmanager().executeTask((
    String taskName,
    Map<String, dynamic>? inputData,
  ) async {
    if (kDebugMode) {
      final now = DateTime.now();
      final today = '${now.year}-${now.month}-${now.day}';
      print('[$today] executeTask: $taskName');
    }

    final currentCount = await SharedPreferencesManager.getCount();

    switch (taskName) {
      case WorkerTaskType.oneOff:
      case Workmanager.iOSBackgroundTask:
        final newCount = currentCount + max<int>(1, Random().nextInt(5));

        /// SharedPreferences에 저장
        SharedPreferencesManager.saveCount(newCount);

        /// Main Isolate의 MainBloc에 메시지 전달
        SendPort? sendPort = IsolatePortManager.getSendPort();

        sendPort?.send(newCount);

        break;

      case WorkerTaskType.periodic:

        /// SharedPreferences에 저장
        SharedPreferencesManager.saveCount(50);

        /// Main Isolate의 MainBloc에 메시지 전달
        SendPort? sendPort = IsolatePortManager.getSendPort();

        sendPort?.send(50);

        break;

      case WorkerTaskType.processing:

        /// SharedPreferences에 저장
        SharedPreferencesManager.saveCount(0);

        /// Main Isolate의 MainBloc에 메시지 전달
        SendPort? sendPort = IsolatePortManager.getSendPort();

        sendPort?.send(0);

        break;
    }

    return Future.value(true);
  });
}
