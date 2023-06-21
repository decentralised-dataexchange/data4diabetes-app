import 'package:Data4Diabetes/app/modules/Dexcom/controllers/dexcom_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../Constants/Palette.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/widget/app_bar_title.dart';
import '../../insights/controllers/insights_controller.dart';
import '/app/core/base/base_view.dart';
import '/app/core/widget/custom_app_bar.dart';

class DexcomView extends BaseView<DexcomController> {
  final InsightsController _insightsController = Get.find();
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Palette.backgroundColor,
      //centerTitle: true,
      elevation: 0,
      automaticallyImplyLeading: true,
      leading: IconButton(
        onPressed: () async {
          SharedPreferences _prefs = await SharedPreferences.getInstance();
          var token = _prefs.getString('access_token');
          if (token != null) {
            _insightsController.estimatedGlucoseValues();
            _insightsController.gMICalculator(
                _insightsController.selectedValue.value = 'TODAY');
            _insightsController.tIRCalculator(
                _insightsController.selectedValue.value = 'TODAY');
            _insightsController.addChartDataValues(
                _insightsController.selectedValue.value = 'TODAY');
          }

          Get.back();
        },
        icon: const Icon(Icons.arrow_back_ios),
      ),
      iconTheme: const IconThemeData(color: AppColors.appBarIconColor),
    );
  }

  final DexcomController _dexcomController = Get.find();
  @override
  Widget body(BuildContext context) {
    return FutureBuilder<String>(
      future: _dexcomController.dexcomLogin(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display a loading spinner while waiting for the future to complete
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Display an error message if the future throws an error
          return Text('Error: ${snapshot.error}');
        } else {
          // Display the fetched data
          return WebViewWidget(controller: _dexcomController.controller!);
        }
      },
    );
  }
}
