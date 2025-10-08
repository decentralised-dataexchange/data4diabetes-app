import 'package:Data4Diabetes/app/Constants/Palette.dart';
import 'package:Data4Diabetes/app/core/values/app_colors.dart';
import 'package:Data4Diabetes/app/core/widget/app_bar_with_logo.dart';
import 'package:Data4Diabetes/app/modules/settings/views/settings_view.dart';
import 'package:Data4Diabetes/app/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/core/base/base_view.dart';
import '/app/modules/home/controllers/home_controller.dart';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class HomeView extends BaseView<HomeController> {
  static const int aspectRatioFrom = 16;
  static const int aspectRatioTo = 10;
  static const int donutWidth = 40;
  static const double labelLinelength = 10;
  static const int labelFontSize = 11;
  static const double containerWidth = 200;
  static const double containerRadius = 25.0;
  static const double mmolFontSize = 40;
  static const int medicationMeasure = 28;
  static const int activitiesMeasure = 27;
  static const int foodMeasure = 20;
  static const int environmentMeasure = 15;
  static const int biologicalMeasure = 15;
  final List<String> icons = ["🧘‍", "🍴", "🫶", "⚕️", "🧬"];
  String barcodeScanRes = "";
  static const double heightValue = 0.1;

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBarWithLogo(
      title: controller.appLocalization.homeYourVirtualPancreas,
    );
  }

  @override
  Widget body(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          _donetChartWidget(),
          SizedBox(height: MediaQuery.of(context).size.height * heightValue),
          SizedBox(
            width: containerWidth,
            child: AppButton(
              radius: containerRadius,
              lefticon: Container(
                  margin: const EdgeInsets.only(right: 5),
                  child: const Icon(
                    Icons.qr_code_scanner_sharp,
                    color: Colors.white,
                  )),
              text: controller.appLocalization.generalShareData,

              onPressed: () {
                controller.platform.invokeMethod('SharedData');
              },
            ),
          ),
        ],
      ),
    );
  }



  Widget _donetChartWidget() {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: AspectRatio(
        aspectRatio: aspectRatioFrom / aspectRatioTo,
        child: Stack(
          children: [
            DChartPie(
              data: [
                {'domain': 'Medication','label':controller.appLocalization.homeMedication, 'measure':medicationMeasure },
                {'domain': 'Activities','label':controller.appLocalization.homeActivities, 'measure': activitiesMeasure},
                {'domain':'Environment','label':controller.appLocalization.homeEnvironment, 'measure': foodMeasure},
                {'domain': 'Food','label':controller.appLocalization.homeFood, 'measure': environmentMeasure},
                {'domain': 'Biological','label':controller.appLocalization.homeBiological, 'measure': biologicalMeasure},
              ],
              fillColor: (pieData, index) {
                switch (pieData['domain']) {
                  case 'Activities':
                    return Colors.orange;
                  case 'Medication':
                    return Colors.green;
                  case 'Food':
                    return Colors.blue[900];
                  case 'Environment':
                    return Colors.blue[200];
                  default:
                    return Colors.purple;
                }
              },
              donutWidth: donutWidth,
              pieLabel: (pieData, index) {
                return "${pieData['label']}";
              },
              labelPosition: PieLabelPosition.outside,
              labelLinelength: labelLinelength,
              labelLineColor: AppColors.lightGreyColor,
              labelPadding: 5,
              labelFontSize: labelFontSize,

            ),
            _sugarLevel(),
          ],
        ),
      ),
    );
  }

  Widget _sugarLevel() {
    return Align(
      child: Obx(() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            controller.glucoseValue.value.toStringAsFixed(1),
            style: TextStyle(
              fontSize: mmolFontSize,
              color: Colors.green[400],
            ),
          ),
          Text(
            'mmol/L',
            style: TextStyle(color: Colors.blueGrey[400]),
          ),
        ],
      )),
    );
  }
}

