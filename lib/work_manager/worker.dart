import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';

import 'worker_dispatcher.dart';
import 'worker_task_type.dart';

class Worker {
  static void init() {
    Workmanager().initialize(
      workerDispatcher,
      isInDebugMode: kDebugMode,
    );
  }

  static void log() {
    Workmanager().printScheduledTasks();
  }

  static void emitOneOff() {
    Workmanager().registerOneOffTask(
      WorkerTaskType.oneOff,
      WorkerTaskType.oneOff,
      existingWorkPolicy: ExistingWorkPolicy.replace,
    );
  }

  /// Android 주기 - 최소 15분
  /// iOS 주기 - 약 30분(시스템에 의해 결정됨)
  static void emitPeriodic() {
    Workmanager().registerPeriodicTask(
      WorkerTaskType.periodic,
      WorkerTaskType.periodic,
      frequency: const Duration(minutes: 15),
      initialDelay: const Duration(seconds: 10),
      existingWorkPolicy: ExistingWorkPolicy.replace,
    );
  }

  static void emitProcessing() {
    if (!Platform.isIOS) return;

    Workmanager().registerProcessingTask(
      WorkerTaskType.periodic,
      WorkerTaskType.periodic,
      initialDelay: const Duration(seconds: 10),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresCharging: true,
      ),
    );
  }
}
