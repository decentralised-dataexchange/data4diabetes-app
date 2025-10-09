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
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      leading: Container(
        height: circleContainerHeight,
        width: circleContainerWidth,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Image.asset(
          'images/blood_drop.png',
          fit: BoxFit.cover,
        ),
      ),
      title: const Text(
        'Data4Diabetes',
        style: TextStyle(
            color: Color.fromARGB(255, 30, 189, 174),
            fontSize: 20,
            fontWeight: FontWeight.bold),
      ),
      subtitle: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min, // Important: keeps the Row compact
        children: [
          IconButton(
            icon: const Icon(
              Icons.refresh_outlined, // <-- your new icon
              color: Colors.blueGrey,
              size: 25,
            ),
            onPressed: () {
              // Generate random glucose value
              final double glucoseValue = getRandomGlucoseValue();

              print("Generated Glucose Value Lijo: $glucoseValue");

              _homeController.updateGlucose(glucoseValue);

              // Build a Map<String, String> for attributes
              final Map<String, String> attributesMap = {
                "date": DateTime.now().toIso8601String(),
                "fasting": glucoseValue.toString(),
                "post_fasting": (glucoseValue+1).toString(),
              };

              // MethodChannel to call Kotlin
              const platform = MethodChannel('io.igrant.data4diabetes.channel');

              // Invoke the Kotlin method
              platform.invokeMethod('addSelfAttestedCredential', {
                "title": "Blood Sugar",
                "description": "Self Attested Glucose Value",
                "attributesMap": attributesMap,
                "connectionName": "Data4Diabetes",
                "location": "sweden",
                "vct": "blood_sugar",
              });
            },
          ),
          IconButton(
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
                    _insightsController.gMICalculator(
                        _insightsController.selectedValue.value = 'TODAY');
                    _insightsController.tIRCalculator(
                        _insightsController.selectedValue.value = 'TODAY');
                    _insightsController.addChartDataValues(
                        _insightsController.selectedValue.value = 'TODAY');
                  }
                }
              });
            },
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