package io.igrant.data4diabetes

import android.content.Intent
import android.util.Log
import android.widget.Toast
import com.github.privacydashboard.PrivacyDashboard
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.github.privacydashboard.utils.ViewMode
import io.flutter.embedding.android.FlutterFragmentActivity
import io.igrant.data_wallet.indy.LedgerNetworkType
import io.igrant.data_wallet.utils.DataWallet
import io.igrant.data_wallet.utils.DataWalletConfigurations
import io.igrant.data_wallet.utils.DeleteWalletResult
import io.igrant.data_wallet.utils.InitializeWalletCallback
import io.igrant.data_wallet.utils.InitializeWalletState
import io.igrant.data_wallet.utils.MessageTypes
import io.igrant.data_wallet.utils.NotificationListener
import io.igrant.data_wallet.utils.SelfAttestedCredential
import io.igrant.data_wallet.utils.SelfAttestedOpenIDCredential
import io.igrant.data_wallet.utils.dataAgreement.DataAgreementUtils
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch

class MainActivity : FlutterFragmentActivity() {

    private val CHANNEL = "io.igrant.data4diabetes.channel"
    var methodChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)



        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel!!.setMethodCallHandler { call, result ->
            Log.d("TAG", "configureFlutterEngine:")
            when (call.method) {
                "Wallet" -> {
                    DataWallet.showWallet(this)
                }
                "Connections" -> {
                    DataWallet.showConnections(this)
                }
                "Notifications" -> {
                    DataWallet.showNotifications(this)
                }
                "MySharedData" -> {
                    DataWallet.showMySharedData(this)
                }
                "SharedData" -> {
                    DataWallet.openShareData(this)
                }
                "Preferences" -> {
                    val apiKey: String? = call.argument("ApiKey")
                    val baseUrl: String? = call.argument("baseUrl")
                    val userId: String? = call.argument("userId")
                    val languageCode: String? = call.argument("languageCode")
                    Log.d("TAG", "configureFlutterEngine: $apiKey $baseUrl $userId $languageCode")
                    PrivacyDashboard.showPrivacyDashboard().withApiKey(
                        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJTY29wZXMiOlsic2VydmljZSJdLCJPcmdhbmlzYXRpb25JZCI6IjY4ZGNmYmE1N2RjMDExYmQ0N2I5NTdjNSIsIk9yZ2FuaXNhdGlvbkFkbWluSWQiOiI2OGRjZmIyMzI1MjJhMDM5NDc0MTU5YTQiLCJEYXRhVmVyaWZpZXJVc2VySWQiOiIiLCJFbnYiOiIiLCJleHAiOjE3NjIwNTgxOTd9.OxBuLi6-gy-ANW28bIHg7CIc5YqTZcPd6HhOR47d3EQ"
                    )
                        .withUserId("68df5f887dc011bd47b95a07")
                        .withBaseUrl("https://staging-api.igrant.io/v2")
                        .withOrganisationId("68dcfba57dc011bd47b957c5")
//                        .enableAskMe()
                        .withLocale(languageCode ?: "sv")
                        .start(this)
                }
                "DataAgreementPolicy" -> {
                    val apiKey: String? = call.argument("ApiKey")
                    val orgId: String? = call.argument("orgId")
                    val dataAgreementId: String? = call.argument("dataAgreementId")

                    DataAgreementUtils.fetchDataAgreement(
                        "ApiKey $apiKey",
                        orgId ?: "",
                        dataAgreementId ?: "",
                        this
                    )

                }
                "QueryCredentials" -> {
                    val credDefId: String? = call.argument("CredDefId")
                    val schemaId: String? = call.argument("SchemaId")

                    val data = DataWallet.queryCredentials(credDefId, schemaId)
                    result.success(data)
                }
                "DataSharing" -> {
                    val apiKey: String? = call.argument("apiKey")
                    val userId: String? = call.argument("userId")
                    val dataAgreementID: String? = call.argument("dataAgreementID")
                    val baseUrl: String? = call.argument("baseUrl")
                    var data: String? = null
                    GlobalScope.launch {
                        data = PrivacyDashboard.optInToDataAgreement(
                            dataAgreementId = dataAgreementID ?: "",
                            baseUrl = baseUrl ?: "",
                            apiKey = apiKey ?: "",
                            userId = userId
                        )
                        if (data != null) {
                            result.success(data)
                        } else {
                            result.error("DataSharing error", "Error occurred. Data: $data", null)
                        }

                    }
                }
                "GetDataAgreement" -> {
                    val apiKey: String? = call.argument("apiKey")
                    val userId: String? = call.argument("userId")
                    val dataAgreementID: String? = call.argument("dataAgreementID")
                    val baseUrl: String? = call.argument("baseUrl")
                    var data: String? = null
                    GlobalScope.launch {
                        data = PrivacyDashboard.getDataAgreement(
                            dataAgreementId = dataAgreementID ?: "",
                            baseUrl = baseUrl ?: "",
                            apiKey = apiKey ?: "",
                            userId = userId ?: ""
                        )
                        if (data != null) {
                            result.success(data)
                        } else {
                            result.error(
                                "GetDataAgreement error",
                                "Error occurred. Data: $data",
                                null
                            )
                        }

                    }
                }
                "GetDataAgreementWithApiKey" -> {
                    val apiKey: String? = call.argument("apiKey")
                    val userId: String? = call.argument("userId")
                    val dataAgreementID: String? = call.argument("dataAgreementID")
                    val baseUrl: String? = call.argument("baseUrl")
                    var data: String? = null
                    GlobalScope.launch {
                        data = PrivacyDashboard.getDataAgreement(
                            dataAgreementId = dataAgreementID ?: "",
                            baseUrl = baseUrl ?: "",
                            apiKey = apiKey ?: "",
                            userId = userId ?: ""
                        )
                        if (data != null) {
                            result.success(data)
                        } else {
                            result.error(
                                "GetDataAgreement error",
                                "Error occurred. Data: $data",
                                null
                            )
                        }

                    }
                }
                "ShowDataAgreementPolicy" -> {
                    val dataAgreementResponse: String? = call.argument("dataAgreementResponse")
                    PrivacyDashboard.showDataAgreementPolicy()
                        .withDataAgreement(dataAgreementResponse ?: "").withLocale("sv").start(this)
                }
                "CreateIndividual" -> {
                    val apiKey: String? = call.argument("apiKey")
                    val baseUrl: String? = call.argument("baseUrl")
                    val name: String? = call.argument("name")
                    val phone: String? = call.argument("phone")
                    val fcmToken: String? = call.argument("fcmToken")
                    val deviceType: String? = call.argument("deviceType")
                    var data: String? = null
                    GlobalScope.launch {
                        data = PrivacyDashboard.createAnIndividual(
                            baseUrl = baseUrl ?: "",
                            apiKey = apiKey ?: "",
                            name = name ?: "",
                            phone = phone ?: "",
                            pushNotificationToken = fcmToken,
                            deviceType = deviceType
                        )
                        if (data != null) {
                            result.success(data)
                        } else {
                            result.error(
                                "GetDataAgreement error",
                                "Error occurred. Data: $data",
                                null
                            )
                        }

                    }
                }
                "UpdateIndividual" -> {
                    val apiKey: String? = call.argument("apiKey")
                    val baseUrl: String? = call.argument("baseUrl")
                    val individualId: String? = call.argument("individualId")
                    val name: String? = call.argument("name")
                    val phone: String? = call.argument("phone")
                    val fcmToken: String? = call.argument("fcmToken")
                    val deviceType: String? = call.argument("deviceType")
                    var data: String? = null
                    GlobalScope.launch {
                        data = PrivacyDashboard.updateTheIndividual(
                            baseUrl = baseUrl ?: "",
                            apiKey = apiKey ?: "",
                            name = name ?: "",
                            phone = phone ?: "",
                            pushNotificationToken = fcmToken,
                            deviceType = deviceType,
                            individualId = individualId ?:"",
                            email = ""
                        )
                        if (data != null) {
                            result.success(data)
                        } else {
                            result.error(
                                "GetDataAgreement error",
                                "Error occurred. Data: $data",
                                null
                            )
                        }

                    }
                }
                "InitWallet"->{
                    initializeWallet()
                }
                "DeleteWallet"->{
                    DataWallet.deleteWallet(this) { result ->
                        when (result) {
                            is DeleteWalletResult.Success -> {
                                DataWallet.releaseSdk()

                            }
                            is DeleteWalletResult.Error -> {

                            }
                        }
                    }
                }
                "handleNotification" -> {
                    val data = call.arguments as? Map<String, String>
                    if (data != null) {
                        // Call DataWallet directly
                        DataWallet.handlePushNotification(data.mapValues { it.value as Any })
                        Log.d("Push", "Notification handled: $data")
                    }
                    result.success(null)
                }
                "addSelfAttestedCredential" -> {
                    val arguments = call.arguments as? Map<String, Any>
                    if (arguments != null) {
                        val title = arguments["title"] as? String ?: "Self Attested"
                        val description = arguments["description"] as? String ?: "Self Attested"
                        val attributesMap = arguments["attributesMap"] as? Map<String, String> ?: mapOf()
                        val connectionName = arguments["connectionName"] as? String ?: "Test Connection"
                        val location = arguments["location"] as? String ?: "Sweden"
                        val vct = arguments["vct"] as? String ?: "open_id_for_self_attested_credentials"
                        val issuedDate = arguments["issuedDate"] as? Long ?: System.currentTimeMillis()
                        val response = SelfAttestedOpenIDCredential().add(
                            title = title,
                            description = description,
                            attributes = attributesMap,
                            connectionName = connectionName,
                            location = location,
                            issuedDate = issuedDate,
                            vct = vct
                        )
                        Log.d("SelfAttested", "Credential added: $response")
                        result.success(null)
                    } else {
                        result.error("INVALID_ARGUMENTS", "Arguments were null or invalid", null)
                    }
                }

            }
        }


    }

    private fun initializeWallet() {
        DataWallet.initializeSdk(
            this,
            object : InitializeWalletCallback {
                override fun progressUpdate(progress: Int) {
                    when (progress) {
                        InitializeWalletState.INITIALIZE_WALLET_STARTED -> {

                        }
                        InitializeWalletState.INITIALIZE_WALLET_EXTERNAL_FILES_LOADED -> {

                        }
                        InitializeWalletState.POOL_CREATED -> {

                        }
                        InitializeWalletState.WALLET_OPENED -> {
                            //  DataWalletConfigurations.registerForSubscription(this@MainActivity)
                            DataWalletConfigurations.registerForSubscription(this@MainActivity,
                                object : NotificationListener {
                                    override fun receivedNotification(
                                        notificationType: String,
                                        intent: Intent
                                    ) {
                                        if (notificationType == MessageTypes.REQUEST_WITH_PIN_ENTRY) {
                                            startActivity(intent)
                                        } else if (notificationType == MessageTypes.VERIFY_REQUEST) {
                                            startActivity(intent)
                                        }

                                    }

                                    override fun walletReadyToUse() {}

                                    override fun pushNotificationResponse(status: Boolean) {
                                        if (status){
                                            Toast.makeText(this@MainActivity, "success", Toast.LENGTH_SHORT).show()
                                        }else{
                                            Toast.makeText(this@MainActivity, "failed", Toast.LENGTH_SHORT).show()
                                        }
                                    }

                                })
                        }
                    }
                }
            }, LedgerNetworkType.getSelectedNetwork(this),
            viewMode = io.igrant.data_wallet.utils.ViewMode.BottomSheet
        )
    }
}
