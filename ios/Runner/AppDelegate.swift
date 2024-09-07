import UIKit
import Flutter
import CallKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

 let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let callLogObserverChannel = FlutterMethodChannel(name: "call_log_channel", binaryMessenger: controller.binaryMessenger)
        let callLogObserver = SwiftCallLogObserver()
        callLogObserverChannel.setMethodCallHandler(callLogObserver.handle)
      GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
