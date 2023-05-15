import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import '/app/my_app.dart';
import '/flavors/build_config.dart';
import '/flavors/env_config.dart';
import '/flavors/environment.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();
  //FirebaseCrashlytics.instance.crash();
  EnvConfig prodConfig = EnvConfig(
    appName: "Flutter GetX Template Prod",
    baseUrl: "https://data4diabetes-staging-api.igrant.io/",
    shouldCollectCrashLog: true,
  );

  BuildConfig.instantiate(
    envType: Environment.PRODUCTION,
    envConfig: prodConfig,
  );

  runApp(const MyApp());
}
