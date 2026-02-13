import 'package:Data4Diabetes/app/modules/home/controllers/home_controller.dart';
import 'package:Data4Diabetes/app/modules/insights/controllers/insights_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constants/Palette.dart';
import '../../modules/settings/views/settings_view.dart';
import 'dart:math';

class AppBarWithLogo extends StatelessWidget  implements PreferredSizeWidget {
  var title;
  bool? isInsight;
  AppBarWithLogo({Key? key,this.title,this.isInsight}) : super(key: key);
  static const double toolbarHeight = 80;
  static const double circleContainerWidth = 50;
  static const double circleContainerHeight = 50;
  final InsightsController _insightsController = Get.find();
  final HomeController _homeController = Get.find();

  @override
  Size get preferredSize => AppBar().preferredSize;
  @override
  Widget build(BuildContext context) {
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
  Widget _appBarListTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Row(
        children: [
          // 1. LEADING ICON
          Container(
            height: circleContainerHeight,
            width: circleContainerWidth,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              'images/blood_drop.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 12),

          // 2. TEXT SECTION (This takes up all available middle space)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Data4Diabetes',
                  style: TextStyle(
                    color: Color.fromARGB(255, 30, 189, 174),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                ),
                Text(
                  title ?? "",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                  maxLines: 1,
                  softWrap: false,
                  // Using scaleDown ensures that if the Swedish word is
                  // still too long, it shrinks the font instead of breaking the UI
                  overflow: TextOverflow.visible,
                ),
              ],
            ),
          ),

          // 3. TRAILING BUTTONS
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.refresh_outlined,
                  color: Colors.blueGrey,
                  size: 25,
                ),
                onPressed: () {
                  final double glucoseValue = getRandomGlucoseValue();
                  _homeController.updateGlucose(glucoseValue);

                  final Map<String, String> attributesMap = {
                    "date": DateTime.now().toIso8601String(),
                    "fasting": glucoseValue.toString(),
                    "post_fasting": (glucoseValue + 1).toString(),
                  };

                  const platform = MethodChannel('io.igrant.data4diabetes.channel');
                  platform.invokeMethod('addSelfAttestedCredential', {
                    "title": "Blood Sugar",
                    "description": "Self Attested Glucose Value",
                    "attributesMap": attributesMap,
                    "connectionName": "Data4Diabetes",
                    "location": "Sweden",
                    "vct": "blood_sugar",
                  });
                },
              ),
              const SizedBox(width: 8), // Spacing between the two buttons
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.settings_outlined,
                  color: Colors.blueGrey,
                  size: 25,
                ),
                onPressed: () {
                  Get.to(SettingsView())?.then((value) async {
                    if (isInsight == true) {
                      SharedPreferences _prefs = await SharedPreferences.getInstance();
                      var token = _prefs.getString('access_token');
                      if (token != null) {
                        _insightsController.estimatedGlucoseValues();
                        _insightsController.gMICalculator('TODAY');
                        _insightsController.tIRCalculator('TODAY');
                        _insightsController.addChartDataValues('TODAY');
                      }
                    }
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
double getRandomGlucoseValue() {
  final random = Random();
  double value = 4.0 + random.nextDouble() * (7.0 - 4.0);
  return double.parse(value.toStringAsFixed(1));
}