import UIKit
import Flutter
import PrivacyDashboardiOS
import ama_ios_sdk
import SwiftMessages

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate,UIGestureRecognizerDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        let flutterViewController : FlutterViewController = window?.rootViewController as! FlutterViewController
//        let navigationController = UINavigationController(rootViewController: flutterViewController)
//        window.rootViewController = navigationController
//        navigationController.delegate = self
        
        let flutterChannel = FlutterMethodChannel(name: "io.igrant.data4diabetes.channel",
                                                   binaryMessenger: flutterViewController.binaryMessenger)
        AriesMobileAgent.shared.configureWallet(delegate: self) { success in
            debugPrint("Wallet configured --- \(success ?? false)")
        }
        flutterChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch call.method{
            case "Preferences":
                BBConsentPrivacyDashboardiOS.shared.show(organisationId: "64f09f778e5f3800014a879a", apiKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyaWQiOiI2NGYwYTYxZThlNWYzODAwMDE0YTg3YTYiLCJvcmdpZCI6IiIsImVudiI6IiIsImV4cCI6MTcyNDU5Njk2MX0.M3I6hJWtOyqbZXQwEGCK43AvROaoR_zncItmULpbFYE", userId: "64f0a61e8e5f3800014a87a6")
                BBConsentPrivacyDashboardiOS.shared.turnOnUserRequests = false
                BBConsentPrivacyDashboardiOS.shared.turnOnAskMeSection = false
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
                guard let arguments = call.arguments as? [String: Any]else {
                    result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
                    return
                }
                let CredDefId = arguments["CredDefId"] as? String ?? ""
                let SchemaId = arguments["SchemaId"] as? String ?? ""
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
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
}

extension AppDelegate: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController == navigationController.viewControllers.first {
            navigationController.isNavigationBarHidden = true
        } else {
            navigationController.isNavigationBarHidden = false
        }
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
