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
              iGrantioSDK.shared.show(organisationId: "638dd3b12f5d1700014431ec", apiKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyaWQiOiI2MzhkZTMzMDJmNWQxNzAwMDE0NDMxZjMiLCJvcmdpZCI6IiIsImVudiI6IiIsImV4cCI6MTcwMTM0NzQ2N30.2q7ENyEIXPRpQ1aF70jcF4XiQJs7YqOHwIogWXt1x5g", userId: "638de3302f5d1700014431f3")
              break
          default: break
          }
      })
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
