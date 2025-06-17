import Flutter
import UIKit
import workmanager

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

     WorkmanagerPlugin.setPluginRegistrantCallback { registry in
      // Registry in this case is the FlutterEngine that is created in Workmanager's
      // performFetchWithCompletionHandler or BGAppRefreshTask.
      // This will make other plugins available during a background operation.
      GeneratedPluginRegistrant.register(with: registry)
    }


    WorkmanagerPlugin.registerBGProcessingTask(withIdentifier: "com.testWorkManager.task-id")


    // Register a periodic task in iOS 13+
    WorkmanagerPlugin.registerPeriodicTask(withIdentifier: "com.testWorkManager.task-period", frequency: NSNumber(value: 15 * 60))


    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
