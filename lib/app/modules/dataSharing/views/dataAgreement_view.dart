

import 'package:Data4Diabetes/app/modules/dataSharing/controllers/dataAgreement_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../Constants/Palette.dart';
import '../../../core/base/base_view.dart';

class DataAgreementView extends BaseView<DataAgreementContoller> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      //centerTitle: true,
      elevation: 0,
      automaticallyImplyLeading: true,
      leading: IconButton(
        onPressed: (){
          Get.back();
        },
        icon: const Icon(Icons.arrow_back_ios),
      ),
    );
  }
  final DataAgreementContoller _dataAgreementContoller = Get.find();
  @override
  Widget body(BuildContext context) {
    return FutureBuilder<String>(
      future:_dataAgreementContoller. invokeDataAgreement(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display a loading spinner while waiting for the future to complete
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Display an error message if the future throws an error
          return Text('Error: ${snapshot.error}');
        } else {
          // Display the fetched data
          return WebViewWidget(controller:_dataAgreementContoller. controller!);
        }
      },
    );
  }
}