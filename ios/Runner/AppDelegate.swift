import UIKit
import Flutter
import iGrantioSDK
import ama_ios_sdk
import SwiftMessages

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
        AriesMobileAgent.shared.configureWallet(delegate: self) { success in
            debugPrint("Wallet configured --- \(success ?? false)")
        }
        carePlanChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch call.method{
            case "Preferences":
                iGrantioSDK.shared.modalPresentationStyle = .fullScreen
                iGrantioSDK.shared.changeSDKMode(mode: .demo)
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
            case "SharedData":
                AriesMobileAgent.shared.showDataWalletScannerViewController()
            default: break
            }
        })

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

extension AppDelegate: AriesMobileAgentDelegate{
    func notificationReceived(message: String) {
        debugPrint("Notification recieved --- \(message)")
        showSuccessSnackbar(message: message,navToNotifScreen: true)
    }
    
    func showSuccessSnackbar(withTitle: String? = "", message: String,navToNotifScreen: Bool = false) {
        DispatchQueue.main.async {
            let success = MessageView.viewFromNib(layout: .messageView)
            success.configureTheme(.success)
            success.backgroundColor = #colorLiteral(red: 0.2666666667, green: 0.5803921569, blue: 0.2666666667, alpha: 1)
            success.configureContent(title: withTitle!, body: message)
            success.configureDropShadow()
            success.button?.isHidden = true
            if navToNotifScreen {
                success.tapHandler = { _ in
                    if (!navToNotifScreen){
                        return
                    }
                    SwiftMessages.hide(animated: false)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                        AriesMobileAgent.shared.showDataWalletNofificationViewController()
                    })
                }
            }
            SwiftMessages.show(view: success)
        }
    }
}
