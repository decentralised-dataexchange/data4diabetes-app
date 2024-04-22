package io.igrant.data4diabetes

import android.util.Log
import com.github.privacyDashboard.PrivacyDashboard
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.igrant.data_wallet.indy.LedgerNetworkType
import io.igrant.data_wallet.utils.DataWallet
import io.igrant.data_wallet.utils.DataWalletConfigurations
import io.igrant.data_wallet.utils.DeleteWalletResult
import io.igrant.data_wallet.utils.InitializeWalletCallback
import io.igrant.data_wallet.utils.InitializeWalletState
import io.igrant.data_wallet.utils.dataAgreement.DataAgreementUtils
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch

class MainActivity : FlutterActivity() {

    private val CHANNEL = "io.igrant.data4diabetes.channel"
    var methodChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)



        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel!!.setMethodCallHandler { call, result ->
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
                    PrivacyDashboard.showPrivacyDashboard().withApiKey(
                        apiKey
                            ?: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJTY29wZXMiOlsic2VydmljZSJdLCJPcmdhbmlzYXRpb25JZCI6IjY0ZjA5Zjc3OGU1ZjM4MDAwMTRhODc5YSIsIk9yZ2FuaXNhdGlvbkFkbWluSWQiOiI2NTBhZTFmYmJlMWViNDAwMDE3MTFkODciLCJleHAiOjE3MzAyMjMyODh9.DlU8DjykYr3eBmbgsKLR4dnaChiRqXdxofKOuk4LiRM"
                    )
                        .withUserId(userId ?: "653fe90efec9f34efed23619")
                        .withBaseUrl(baseUrl ?: "https://demo-consent-bb-api.igrant.io/v2")
//                        .enableUserRequest()
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
                        .withDataAgreement(dataAgreementResponse ?: "").withLocale("en").start(this)
                }
                "CreateIndividual" -> {
                    val apiKey: String? = call.argument("apiKey")
                    val baseUrl: String? = call.argument("baseUrl")
                    var data: String? = null
                    GlobalScope.launch {
                        data = PrivacyDashboard.createAnIndividual(
                            baseUrl = baseUrl ?: "",
                            apiKey = apiKey ?: "",
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
                    val response = DataWallet.deleteWallet()
                    when (response) {
                        is DeleteWalletResult.Success -> {
                            // Show success message or perform any other action
                            DataWallet.releaseSdk()
                            Log.d("Success","${response.message}")
                        }
                        is DeleteWalletResult.Error -> {
                            // error message
                            Log.d("Error","${response.errorMessage}")
                        }
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
                            DataWalletConfigurations.registerForSubscription(this@MainActivity)
                        }
                    }
                }
            }, LedgerNetworkType.getSelectedNetwork(this)
        )
    }
}
