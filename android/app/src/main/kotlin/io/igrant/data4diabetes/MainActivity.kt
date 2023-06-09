package io.igrant.data4diabetes

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.igrant.data_wallet.indy.LedgerNetworkType
import io.igrant.data_wallet.utils.DataWallet
import io.igrant.data_wallet.utils.DataWalletConfigurations
import io.igrant.data_wallet.utils.InitializeWalletCallback
import io.igrant.data_wallet.utils.InitializeWalletState
import io.igrant.data_wallet.utils.dataAgreement.DataAgreementUtils
import io.igrant.igrant_org_sdk.utils.IgrantSdk

class MainActivity : FlutterActivity() {

    private val CHANNEL = "io.igrant.data4diabetes.channel"
    var methodChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
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
                    IgrantSdk().withApiKey("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyaWQiOiI2NDVhNDE0YmI5YjA1NTAwMDE1MGIyNDciLCJvcmdpZCI6IiIsImVudiI6IiIsImV4cCI6MTcxNDc0MDg4Nn0.u6pBpv12ZfdHYMPoQHYR-oBR9ZOZVeHiChaQ8yiEMxE")
                        .withUserId("5d8db1428e252f000180b5a6")
                        .withOrgId("645a4172b9b055000150b248").start(this)
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
            }
        }


    }
}
