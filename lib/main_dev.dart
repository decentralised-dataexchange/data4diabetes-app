import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import '/app/my_app.dart';
import '/flavors/build_config.dart';
import '/flavors/env_config.dart';
import '/flavors/environment.dart';
import 'app/pushnotification/push_helper.dart';

void main() async {
  EnvConfig devConfig = EnvConfig(
    appName: "Data4Diabetes",
    baseUrl: "https://data4diabetes-staging-api.igrant.io/",
    dexComBaseUrl: "https://sandbox-api.dexcom.com",
    shouldCollectCrashLog: true,
  );

  BuildConfig.instantiate(
    envType: Environment.DEVELOPMENT,
    envConfig: devConfig,
  );
  debugPrint("Config -- main_dev");

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  // 🔥 Initialize Push Helper
  await PushHelper.init();
  runApp(const MyApp());
}
