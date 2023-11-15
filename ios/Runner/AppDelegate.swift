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
                let arguments = call.arguments as? [String: Any]
                let apiKey = arguments?["ApiKey"] as? String
                let orgId = arguments?["orgId"] as? String
                let baseUrl = arguments?["baseUrl"] as? String
                let userId = arguments?["userId"] as? String

                PrivacyDashboard.showPrivacyDashboard(withApiKey: apiKey ?? "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJTY29wZXMiOlsic2VydmljZSJdLCJPcmdhbmlzYXRpb25JZCI6IjY0ZjA5Zjc3OGU1ZjM4MDAwMTRhODc5YSIsIk9yZ2FuaXNhdGlvbkFkbWluSWQiOiI2NTBhZTFmYmJlMWViNDAwMDE3MTFkODciLCJleHAiOjE3MzAyNjczNDV9.hNCwZjcObSCVA_O5B-yq0EVhJlxtO2uR75ThIriq2Jk",
                                           withUserId: userId ?? "6540952ffec9f34efed236c9",
                                           withOrgId: orgId ?? "64f09f778e5f3800014a879a",
                                           withBaseUrl: baseUrl ?? "https://demo-consent-bb-api.igrant.io/v2",
                                           turnOnAskme: false, turnOnUserRequest: false, turnOnAttributeDetail: false)
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
            case "DataSharing":
                    let arguments = call.arguments as? [String: Any]
                    let apiKey = arguments?["apiKey"] as? String
                    let userId = arguments?["userId"] as? String
                    let dataAgreementID = arguments?["dataAgreementID"] as? String
                    let baseUrl = arguments?["baseUrl"] as? String
                    var data: String? = nil

                    PrivacyDashboard.configure(withApiKey: apiKey ?? "", withUserId: userId ?? "", withOrgId: "", withBaseUrl: String(baseUrl ?? ""), accessToken: "")
                    PrivacyDashboard.updateDataAgreementStatus(dataAgreementId: dataAgreementID ?? "", status: true)
                    PrivacyDashboard.receiveDataBackFromPrivacyDashboard = { dataReceived in
                      let dict = dataReceived["consentRecord"] as? [String: Any]
                      if let theJSONData = try? JSONSerialization.data(withJSONObject: dict ?? [:], options: .prettyPrinted),
                        let theJSONText = String(data: theJSONData, encoding: String.Encoding.ascii) {
                        print("JSON string = \n\(theJSONText)")
                        data = theJSONText
                      }

                      if data != nil {
                        result(data)
                      } else {
                        result(FlutterError(code: "DataSharing error", message: "Error occurred. Data: \(data ?? "")", details: nil))
                      }
                    }
            case "GetDataAgreement":
                    let arguments = call.arguments as? [String: Any]
                    let apiKey = arguments?["apiKey"] as? String
                    let userId = arguments?["userId"] as? String
                    let dataAgreementID = arguments?["dataAgreementID"] as? String
                    let baseUrl = arguments?["baseUrl"] as? String
                    var data: String? = nil

                    PrivacyDashboard.configure(withApiKey: apiKey ?? "", withUserId: userId ?? "", withOrgId: "", withBaseUrl: String(baseUrl?.dropLast() ?? ""), accessToken: "")
                    PrivacyDashboard.readDataAgreementApi(dataAgreementId: dataAgreementID ?? "") { success, resultVal in
                      debugPrint("Data receieved here:\(resultVal)")
                      let dict = resultVal["dataAgreement"] as? [String: Any]
                      if let theJSONData = try? JSONSerialization.data(withJSONObject: dict ?? [:], options: .prettyPrinted),
                        let theJSONText = String(data: theJSONData, encoding: String.Encoding.ascii) {
                        debugPrint("JSON string = \n\(theJSONText)")
                        data = theJSONText
                      }

                      if data != nil {
                        result(data)
                      } else {
                        result(FlutterError(code: "DataSharing error", message: "Error occurred. Data: \(data ?? "")", details: nil))
                      }
                    }
            case "GetDataAgreementWithApiKey":
                    let arguments = call.arguments as? [String: Any]
                    let apiKey = arguments?["apiKey"] as? String
                    let userId = arguments?["userId"] as? String
                    let dataAgreementID = arguments?["dataAgreementID"] as? String
                    let baseUrl = arguments?["baseUrl"] as? String
                    var data: String? = nil

                    PrivacyDashboard.configure(withApiKey: apiKey ?? "", withUserId: userId ?? "", withOrgId: "", withBaseUrl: String(baseUrl?.dropLast() ?? ""), accessToken: "")
                    PrivacyDashboard.readDataAgreementApi(dataAgreementId: dataAgreementID ?? "") { success, resultVal in
                      debugPrint("Data receieved here:\(resultVal)")
                      let dict = resultVal["dataAgreement"] as? [String: Any]
                      if let theJSONData = try? JSONSerialization.data(withJSONObject: dict ?? [:], options: .prettyPrinted),
                        let theJSONText = String(data: theJSONData, encoding: String.Encoding.ascii) {
                        debugPrint("JSON string = \n\(theJSONText)")
                        data = theJSONText
                      }

                      if data != nil {
                        result(data)
                      } else {
                        result(FlutterError(code: "DataSharing error", message: "Error occurred. Data: \(data ?? "")", details: nil))
                      }
                    }
            case "CreateIndividual":
                    var data: String? = nil
                    let dict = ["id":"6553af58ec660dae93f6e254", "externalId": "","externalIdType":"", "identityProviderId":"", "name": "Flutter app", "iamId": "a2bd807c-fde4-40e8-8bfd-ff715d596492", "email":"flutterapp@yupmail.com", "phone": "9876987698"]
                    let individualDict = ["individual": dict]
                    if let jsonData = try? JSONSerialization.data(withJSONObject: individualDict, options: .prettyPrinted),
                      let theJSONText = String(data: jsonData, encoding: String.Encoding.ascii) {
                       debugPrint("JSON string = \n\(theJSONText)")
                       data = theJSONText
                    }
                    if data != nil {
                      result(data)
                    } else {
                      result(FlutterError(code: "DataSharing error", message: "Error occurred. Data: \(data ?? "")", details: nil))
                    }
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
