import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import '/app/my_app.dart';
import '/flavors/build_config.dart';
import '/flavors/env_config.dart';
import '/flavors/environment.dart';
import 'push_helper.dart';

void main() async {
  EnvConfig prodConfig = EnvConfig(
    appName: "Data4Diabetes",
    baseUrl: "https://data4diabetes-staging-api.igrant.io/",
    dexComBaseUrl: "https://sandbox-api.dexcom.com",
    servicesBaseUrl: "https://staging-api.igrant.io",
    shouldCollectCrashLog: true,
  );

  BuildConfig.instantiate(
    envType: Environment.PRODUCTION,
    envConfig: prodConfig,
  );
  debugPrint("Config -- main_prod");

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  requestPermission();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  // 🔥 Initialize Push Helper
  await PushHelper.init();
  runApp(const MyApp());
}

void requestPermission() async {
  NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined permission');
  }
}
