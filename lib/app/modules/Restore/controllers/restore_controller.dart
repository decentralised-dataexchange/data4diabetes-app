import 'package:Data4Diabetes/app/core/base/base_controller.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../main/views/main_view.dart';

class RestoreController extends BaseController {
  var platform = const MethodChannel('io.igrant.data4diabetes.channel');
  static const int _pollIntervalMs = 500;
  static const int _pollWaitingTime = 10000;

  Future<void> restore() async {

    try {
        final restoreResponse = await platform.invokeMethod('Restore');

        if (restoreResponse == "restored") {
          await waitForWalletData();
          final response = await platform.invokeMethod('InitWallet');
          if (response == "walletReadyToUse") {
            Get.offAll(MainView());
          } else {
            GetSnackToast(message: "Wallet initialization failed");
          }
        } else {
          GetSnackToast(message: "Restore failed");
        }
    } on PlatformException catch (e) {
      GetSnackToast(message: "Restore failed: ${e.message}");
    } catch (e) {
      GetSnackToast(message: "Unknown error occurred");
    }
  }
  Future<void> waitForWalletData({int timeoutMs = _pollWaitingTime}) async {
    int waited = 0;
    while (true) {
      final data = await platform.invokeMethod('QueryCredentials');
      if (data != null && data.isNotEmpty) break;

      if (waited >= timeoutMs) {
        throw Exception("Timeout waiting for wallet data");
      }

      await Future.delayed(Duration(milliseconds: _pollIntervalMs));
      waited += _pollIntervalMs;
    }
  }
}

