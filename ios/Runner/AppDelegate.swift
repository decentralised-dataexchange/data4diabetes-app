import UIKit
import Flutter
import iGrantioSDK
import ama_ios_sdk

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
//    let flutterViewController = controller
//      // Wrap the FlutterViewController inside a UINavigationController
//      let navigationController = UINavigationController(rootViewController: flutterViewController)
//      // Set the root view controller as the navigation controller
//      window.rootViewController = navigationController
    let carePlanChannel = FlutterMethodChannel(name: "io.igrant.data4diabetes.channel",
                                                 binaryMessenger: controller.binaryMessenger)
      AriesMobileAgent.shared.configureWallet { success in
          debugPrint("Wallet configured --- \(success ?? false)")
      }
      carePlanChannel.setMethodCallHandler({
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          switch call.method{
            case "Preferences":
              iGrantioSDK.shared.modalPresentationStyle = .fullScreen
              iGrantioSDK.shared.show(organisationId: "645a4172b9b055000150b248", apiKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyaWQiOiI2NDVhNDE0YmI5YjA1NTAwMDE1MGIyNDciLCJvcmdpZCI6IiIsImVudiI6IiIsImV4cCI6MTcxNDc0MDg4Nn0.u6pBpv12ZfdHYMPoQHYR-oBR9ZOZVeHiChaQ8yiEMxE", userId: "5d8db1428e252f000180b5a6")
              break
          case "Wallet":
              AriesMobileAgent.shared.showDataWalletHomeViewController(showBackButton: true)
          case "Connections":
              AriesMobileAgent.shared.showDataWalletConnectionsViewController()
          case "MySharedData":
              AriesMobileAgent.shared.showDataWalletShareDataHistoryViewController()
          case "Notifications":
              AriesMobileAgent.shared.showDataWalletNofificationViewController()
          default: break
          }
      })
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
