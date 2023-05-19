import UIKit
import Flutter
import iGrantioSDK

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let carePlanChannel = FlutterMethodChannel(name: "io.igrant.data4diabetes.channel",
                                                 binaryMessenger: controller.binaryMessenger)
      carePlanChannel.setMethodCallHandler({
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          switch call.method{
            case "Preferences":
              iGrantioSDK.shared.modalPresentationStyle = .fullScreen
              iGrantioSDK.shared.show(organisationId: "645a4172b9b055000150b248", apiKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyaWQiOiI2NDVhNDE0YmI5YjA1NTAwMDE1MGIyNDciLCJvcmdpZCI6IiIsImVudiI6IiIsImV4cCI6MTcxNDc0MDg4Nn0.u6pBpv12ZfdHYMPoQHYR-oBR9ZOZVeHiChaQ8yiEMxE", userId: "5d8db1428e252f000180b5a6")
              break
          default: break
          }
      })
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
