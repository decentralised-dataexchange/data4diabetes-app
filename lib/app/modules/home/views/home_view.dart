import 'package:Data4Diabetes/app/Constants/Palette.dart';
import 'package:Data4Diabetes/app/modules/settings/views/settings_view.dart';
import 'package:Data4Diabetes/app/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/core/base/base_view.dart';
import '/app/modules/home/controllers/home_controller.dart';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class HomeView extends BaseView<HomeController> {
  static const double toolbarHeight = 80;
  static const int aspectRatioFrom = 16;
  static const int aspectRatioTo = 10;
  static const int donutWidth = 40;
  static const double labelLinelength = 16;
  static const int labelFontSize = 12;
  static const double containerWidth = 200;
  static const double circleContainerWidth = 50;
  static const double circleContainerHeight = 50;
  static const double containerRadius = 25.0;
  static const double mmolFontSize = 40;
  final List<String> icons = ["🧘‍", "🍴", "🫶", "⚕️", "🧬"];
  String barcodeScanRes = "";
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      toolbarHeight: toolbarHeight,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Palette.white,
      title: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _appBarListTile(),
          const SizedBox(
            height: 8.0,
          ),
          const Divider(
            height: 2.0,
            thickness: 1,
          ),
        ],
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          _donetChartWidget(),
          Center(
            child: SizedBox(
              width: containerWidth,
              child: AppButton(
                radius: containerRadius,
                lefticon: Container(
                    margin: const EdgeInsets.only(right: 5),
                    child: const Icon(
                      Icons.qr_code_scanner_sharp,
                      color: Colors.white,
                    )),
                text: controller.appLocalization.shareData,
                // onPressed: () => scanQRcode(),
                onPressed: () {
                  return;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  scanQRcode() async {
    barcodeScanRes = "";
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", false, ScanMode.DEFAULT);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platfom version.';
    }

    barcodeScanRes = barcodeScanRes;
  }

  Widget _donetChartWidget() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: AspectRatio(
        aspectRatio: aspectRatioFrom / aspectRatioTo,
        child: Stack(
          children: [
            DChartPie(
              data: const [
                {'domain': 'Medication', 'measure': 28},
                {'domain': 'Activities', 'measure': 27},
                {'domain': 'Food', 'measure': 20},
                {'domain': 'Environment', 'measure': 15},
                {'domain': 'Biological', 'measure': 15},
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
                return "${pieData['domain']}";
              },
              labelPosition: PieLabelPosition.outside,
              labelLinelength: labelLinelength,
              labelPadding: 5,
              labelFontSize: labelFontSize,
            ),
            // _internalIconDonet(),
            _sugarLevel(),
          ],
        ),
      ),
    );
  }

  Widget _sugarLevel() {
    return Align(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '5.6',
          style: TextStyle(fontSize: mmolFontSize, color: Colors.green[400]),
        ),
        Text(
          'mmol/l',
          style: TextStyle(color: Colors.blueGrey[400]),
        )
      ],
    ));
  }

  Widget _internalIconDonet() {
    return DChartPie(
      data: const [
        {'domain': 'Medication', 'measure': 28},
        {'domain': 'Activities', 'measure': 27},
        {'domain': 'Food', 'measure': 20},
        {'domain': 'Environment', 'measure': 15},
        {'domain': 'Biological', 'measure': 15},
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
        return icons[index!];
      },
      labelPosition: PieLabelPosition.inside,
    );
  }

  Widget _appBarListTile() {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      leading: Container(
        height: circleContainerHeight,
        width: circleContainerWidth,

        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),

        //backgroundImage: AssetImage('images/blood_drop.png'),
        child: Image.asset(
          'images/blood_drop.png',
          fit: BoxFit.cover,
        ),
      ),
      title: const Text(
        'Data4Diabetes',
        style: TextStyle(
            color: Color.fromARGB(255, 30, 189, 174),
            fontSize: 25,
            fontWeight: FontWeight.bold),
      ),
      subtitle: const Text('Your vertual pancreas'),
      trailing: IconButton(
        icon: const Icon(
          Icons.settings_outlined,
          color: Colors.blueGrey,
          size: 30,
        ),
        onPressed: () {
          Get.to(SettingsView());
        },
      ),
    );
  }
}
