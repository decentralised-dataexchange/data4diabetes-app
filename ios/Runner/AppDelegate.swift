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
                iGrantioSDK.shared.show(organisationId: "638dd3b12f5d1700014431ec", apiKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyaWQiOiI2MzhkZTMzMDJmNWQxNzAwMDE0NDMxZjMiLCJvcmdpZCI6IiIsImVudiI6IiIsImV4cCI6MTcwMTM0NzQ2N30.2q7ENyEIXPRpQ1aF70jcF4XiQJs7YqOHwIogWXt1x5g", userId: "638de3302f5d1700014431f3")
                break
            case "Wallet":
                AriesMobileAgent.shared.showDataWalletHomeViewController(showBackButton: true)
            case "Connections":
                AriesMobileAgent.shared.showDataWalletConnectionsViewController()
            case "MySharedData":
                AriesMobileAgent.shared.showDataWalletShareDataHistoryViewController()
            case "Notifications":
                AriesMobileAgent.shared.showDataWalletNofificationViewController()
            case "DataAgreementPolicy":
                guard let arguments = call.arguments as? [String: Any],
                      let apiKey = arguments["ApiKey"] as? String,
                      let orgId = arguments["orgId"] as? String,
                      let dataAgreementId = arguments["dataAgreementId"] as? String else {
                    result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
                    return
                }
                AriesMobileAgent.shared.showDataAgreementScreen(dataAgreementID: dataAgreementId, apiKey: apiKey, orgId: orgId)
            case "QueryCredentials":
                guard let arguments = call.arguments as? [String: Any],
                      let CredDefId = arguments["CredDefId"] as? String,
                      let SchemaId = arguments["SchemaId"] as? String else {
                    result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
                    return
                }
                Task{
                    let queryResult = await AriesMobileAgent.shared.queryCredentials(CredDefId: CredDefId, SchemaId: SchemaId)
                    result(queryResult)
                }
            case "SetLanguage":
                guard let arguments = call.arguments as? [String: Any],
                      let code = arguments["code"] as? String else {
                    result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
                    return
                }
                AriesMobileAgent.shared.changeSDKLanguage(languageCode: code)
            default: break
            }
        })

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
