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
      showLoading();
      final restoreResponse = await platform.invokeMethod('Restore');

      if (restoreResponse == "restored") {
        final response = await platform.invokeMethod('InitWallet');
        if (response == "walletReadyToUse") {
          hideLoading();
          Get.offAll(MainView());
        } else {
          hideLoading();
          GetSnackToast(message: "Wallet initialization failed");
        }
      } else {
        hideLoading();
        GetSnackToast(message: "Restore failed");
      }
    } on PlatformException catch (e) {
      hideLoading();
      GetSnackToast(message: "Restore failed: ${e.message}");
    } catch (e) {
      hideLoading();
      GetSnackToast(message: "Unknown error occurred");
    }
  }
}