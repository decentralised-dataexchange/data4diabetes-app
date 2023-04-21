package io.igrant.data4diabetes

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.igrant.data_wallet.indy.LedgerNetworkType
import io.igrant.data_wallet.utils.DataWallet
import io.igrant.data_wallet.utils.InitializeWalletCallback
import io.igrant.data_wallet.utils.InitializeWalletState
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
//                            DataWalletConfigurations.registerForSubscription(this)
                        }
                    }
                }
            }, LedgerNetworkType.getSelectedNetwork(this)
        )


        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel!!.setMethodCallHandler { call, result ->
            when (call.method) {
                "Wallet"->{
                    DataWallet.showWallet(this)
                }
                "Connections"->{
                    DataWallet.showConnections(this)
                }
                "Notifications"->{
                    DataWallet.showNotifications(this)
                }
                "Preferences"->{
                    IgrantSdk().withApiKey("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyaWQiOiI2MzhkZTMzMDJmNWQxNzAwMDE0NDMxZjMiLCJvcmdpZCI6IiIsImVudiI6IiIsImV4cCI6MTcwMTM0NzQ2N30.2q7ENyEIXPRpQ1aF70jcF4XiQJs7YqOHwIogWXt1x5g")
                        .withUserId("638de3302f5d1700014431f3")
                        .withOrgId("638dd3b12f5d1700014431ec").start(this)
                }
            }
        }


    }
}
