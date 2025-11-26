import UIKit
import Flutter
import PrivacyDashboardiOS
import ama_ios_sdk
import SwiftMessages
import Firebase

@main
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate {
    
    override func application(_ application: UIApplication,
                       didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
      }
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
            UNUserNotificationCenter.current().delegate = self
        
        GeneratedPluginRegistrant.register(with: self)
        let flutterViewController : FlutterViewController = window?.rootViewController as! FlutterViewController

        let flutterChannel = FlutterMethodChannel(name: "io.igrant.data4diabetes.channel",
                                                   binaryMessenger: flutterViewController.binaryMessenger)
        flutterChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch call.method{
            case "InitWallet":
                AriesMobileAgent.shared.configureWallet(delegate: self, viewMode: ViewMode.BottomSheet) { success in
                    debugPrint("Wallet configured --- \(success ?? false)")
                }
            case "DeleteWallet":
                AriesMobileAgent.shared.deleteWallet(completion: { success in
                    debugPrint("Wallet deleted --- \(success ?? false)")
                })
            case "Preferences":
                let arguments = call.arguments as? [String: Any]
                let apiKey = arguments?["ApiKey"] as? String
                let orgId = arguments?["orgId"] as? String
                let baseUrl = arguments?["baseUrl"] as? String
                let userId = arguments?["userId"] as? String
                let languageCode = arguments?["languageCode"] as? String

                PrivacyDashboard.showPrivacyDashboard(withApiKey: apiKey ?? "",
                                       withUserId: userId ?? "",
                                       withOrgId: orgId ?? "68f02498a925e3c4c2a92b15",
                                       withBaseUrl: baseUrl ?? "https://demo-api.igrant.io/v2",
                                       withLocale: languageCode ?? "en",
                                       turnOnAskme: false,
                                       turnOnUserRequest: false,
                                       turnOnAttributeDetail: false,
                                       onConsentChange: { success, resultVal, consentRecordID in
                      debugPrint("Consent change here:\(success) - \(resultVal) \(consentRecordID)")
                    }, viewMode: .bottomSheet)
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
                    let accessToken = arguments?["accessToken"] as? String
                    let languageCode = arguments?["languageCode"] as? String
                    var data: String? = nil

                    PrivacyDashboard.configure(withApiKey: apiKey ?? "", withUserId: userId ?? "", withOrgId: "", withBaseUrl: String(baseUrl ?? ""), withLocale: languageCode ?? "en", accessToken: accessToken ?? "")
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
                    let accessToken = arguments?["accessToken"] as? String
                    let languageCode = arguments?["languageCode"] as? String
                    var data: String? = nil

                    PrivacyDashboard.configure(withApiKey: apiKey ?? "", withUserId: userId ?? "", withOrgId: "", withBaseUrl: String(baseUrl ?? ""), withLocale: languageCode ?? "en", accessToken: accessToken ?? "")
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
                    let accessToken = arguments?["accessToken"] as? String
                    let languageCode = arguments?["languageCode"] as? String
                    var data: String? = nil

                PrivacyDashboard.configure(withApiKey: apiKey ?? "", withUserId: userId ?? "", withOrgId: "", withBaseUrl: String(baseUrl ?? ""), withLocale: languageCode ?? "en", accessToken: accessToken ?? "")
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
            case "GetIndividual":
                var data: String? = nil
                let arguments = call.arguments as? [String: Any]
                let apiKey = arguments?["apiKey"] as? String
                let accessToken = arguments?["accessToken"] as? String
                let baseUrl = arguments?["baseUrl"] as? String
                let userId = arguments?["userId"] as? String
                let languageCode = arguments?["languageCode"] as? String
                let individualId = arguments?["individualId"] as? String
                
                PrivacyDashboard.configure(withApiKey: apiKey ?? "", withUserId: userId ?? "", withOrgId: "", withBaseUrl: String(baseUrl ?? ""), withLocale: languageCode ?? "en" , accessToken: accessToken ?? "")
                
                PrivacyDashboard.readAnIndividual(individualId: individualId ?? "") { success, resultVal in
                  if success {
                    if let jsonData = try? JSONSerialization.data(withJSONObject: resultVal, options: .prettyPrinted),
                      let theJSONText = String(data: jsonData, encoding: String.Encoding.ascii) {
                      debugPrint("JSON string = \n\(theJSONText)")
                      data = theJSONText
                    }

                    if data != nil {
                      result(data)
                    } else {
                      result(FlutterError(code: "DataSharing error", message: "Error occurred. Data: \(data ?? "")", details: nil))
                    }
                  }
                }
            case "CreateIndividual":
                    var data: String? = nil
                    let arguments = call.arguments as? [String: Any]
                    let apiKey = arguments?["apiKey"] as? String
                    let userId = arguments?["userId"] as? String
                    let accessToken = arguments?["accessToken"] as? String
                    let baseUrl = arguments?["baseUrl"] as? String
                    let languageCode = arguments?["languageCode"] as? String
                    let name = arguments?["name"] as? String
                    let phone = arguments?["phone"] as? String
                    let fcmToken = arguments?["fcmToken"] as? String
                    let deviceType = "ios"

                    PrivacyDashboard.configure(withApiKey: apiKey ?? "", withUserId: userId ?? "", withOrgId: "", withBaseUrl: String(baseUrl ?? ""), withLocale: languageCode ?? "en" , accessToken: accessToken ?? "")
                    PrivacyDashboard.createAnIndividual(name: name ?? "",
                                                        email: "",
                                                        phone: phone ?? "",
                                                        pushNotificationToken: fcmToken ?? "",
                                                        deviceType: deviceType ?? "") { success, resultVal in
                      if success {
                        if let jsonData = try? JSONSerialization.data(withJSONObject: resultVal, options: .prettyPrinted),
                          let theJSONText = String(data: jsonData, encoding: String.Encoding.ascii) {
                          debugPrint("JSON string = \n\(theJSONText)")
                          data = theJSONText
                        }

                        if data != nil {
                          result(data)
                        } else {
                          result(FlutterError(code: "DataSharing error", message: "Error occurred. Data: \(data ?? "")", details: nil))
                        }
                      }
                    }
                
            case "UpdateIndividual":
                var data: String? = nil
                let arguments = call.arguments as? [String: Any]
                let apiKey = arguments?["apiKey"] as? String
                let userId = arguments?["userId"] as? String
                let accessToken = arguments?["accessToken"] as? String
                let baseUrl = arguments?["baseUrl"] as? String
                let languageCode = arguments?["languageCode"] as? String
                let individualId = arguments?["individualId"] as? String
                let name = arguments?["name"] as? String
                let phone = arguments?["phone"] as? String
                let fcmToken = arguments?["fcmToken"] as? String
                let deviceType = "ios"
                
                PrivacyDashboard.configure(withApiKey: apiKey ?? "", withUserId: userId ?? "", withOrgId: "", withBaseUrl: String(baseUrl ?? ""), withLocale: languageCode ?? "en" , accessToken: accessToken ?? "")
                PrivacyDashboard.updateAnIndividual(individualId: individualId ?? "", externalId: "", externalIdType: "", identityProviderId: "", name: name ?? "", iamId: "", email: "", phone: phone ?? "", pushNotificationToken: fcmToken ?? "", deviceType: deviceType ?? "") { success, resultVal in
                    if success {
                        if let jsonData = try? JSONSerialization.data(withJSONObject: resultVal, options: .prettyPrinted),
                           let theJSONText = String(data: jsonData, encoding: String.Encoding.ascii) {
                            debugPrint("JSON string = \n\(theJSONText)")
                            data = theJSONText
                        }
                        
                        if data != nil {
                            result(data)
                        } else {
                            result(FlutterError(code: "DataSharing error", message: "Error occurred. Data: \(data ?? "")", details: nil))
                        }
                    }
                }
            case "handleNotification":
                var data: String? = nil
                let arguments = call.arguments as? [String: Any]
                
                AriesMobileAgent.shared.handlePushNotification(data: arguments ?? [:] ){ type, continueFlow in
                    DispatchQueue.main.async {
                        if type == .PinEntryDuringIssuance {
                            let success = MessageView.viewFromNib(layout: .messageView)
                            success.configureTheme(.success)
                            success.backgroundColor = #colorLiteral(red: 0.2666666667, green: 0.5803921569, blue: 0.2666666667, alpha: 1)
                            success.configureContent(title: "", body: "Please enter PIN to proceed")
                            success.configureDropShadow()
                            success.button?.isHidden = true
                            // When user taps on the snackbar, continue the flow
                            success.tapHandler = { _ in
                                SwiftMessages.hide()
                                continueFlow()
                            }
                            SwiftMessages.show(view: success)
                        } else if type == .Verification {
                            let success = MessageView.viewFromNib(layout: .messageView)
                            success.configureTheme(.success)
                            success.backgroundColor = #colorLiteral(red: 0.2666666667, green: 0.5803921569, blue: 0.2666666667, alpha: 1)
                            success.configureContent(title: "", body: "Verification request received")
                            success.configureDropShadow()
                            success.button?.isHidden = true
                            // When user taps on the snackbar, continue the flow
                            success.tapHandler = { _ in
                                SwiftMessages.hide()
                                continueFlow()
                            }
                            SwiftMessages.show(view: success)
                        }
                    }
                }
            case "addSelfAttestedCredential":
                var data: String? = nil
                let arguments = call.arguments as? [String: Any]
                let title = arguments?["title"] as? String
                let description = arguments?["description"] as? String
                let attributesMap = arguments?["attributesMap"] as? [String: String]
                let connectionName = arguments?["connectionName"] as? String
                let location = arguments?["location"] as? String
                let vct = arguments?["vct"] as? String
                let issuedDate = arguments?["issuedDate"] as? String
                
                var attributesArray: [[String: String]] = []
                      if let attributesDict = attributesMap {
                        for (key, value) in attributesDict {
                          attributesArray.append([key: value])
                        }
                      }
                Task {
                    do {
                        let id = try await SelfAttestedOpenIDCredential().add(title: title, description: description, attributes: attributesArray, connectionName: connectionName, connectionLocation: location, vct: vct, logo: "https://storage.googleapis.com/igrant-api-images/data4diabetes_final.jpeg")
                    } catch {
                        debugPrint(error)
                    }
                }
                    
            case "ShowDataAgreementPolicy":
                    let arguments = call.arguments as? [String: Any]
                    do {
                      let agreement = arguments?["dataAgreementResponse"] as! String
                      let dict = try JSONSerialization.jsonObject(with: agreement.data(using: .utf8)!, options: []) as! [String:Any]
                      PrivacyDashboard.showDataAgreementPolicy(dataAgreementDic: dict, viewMode: .bottomSheet)
                    } catch {
                      debugPrint(error)
                    }
            case "Backup":
                  AriesMobileAgent.shared.initiateBackup()
            case "Restore":
                 AriesMobileAgent.shared.deleteWallet(completion: { success in
                    if success ?? false {
                        AriesMobileAgent.shared.initiateRestore() { success in
                            result("restored")
                        }
                    }
                 })
            case "Restore":
                 AriesMobileAgent.shared.deleteWallet(completion: { success in
                    if success ?? false {
                        result("WalletDeleted")
                    }
                 })
            default: break
            }
        })

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
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
                        AriesMobileAgent.shared.showNotificationDetails()
                    })
                }
            }
            SwiftMessages.show(view: success)
        }
    }
    func getFlutterRootView() -> UIView? {
        return UIApplication.shared.windows
            .first(where: { $0.rootViewController is FlutterViewController })?
            .rootViewController?.view
    }
}
