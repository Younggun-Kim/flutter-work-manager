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
