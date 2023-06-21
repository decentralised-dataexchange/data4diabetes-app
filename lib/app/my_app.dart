import 'dart:ui';

import 'package:Data4Diabetes/app/LanguageSupport.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/app/bindings/initial_binding.dart';
import '/app/core/values/app_colors.dart';
import '/app/routes/app_pages.dart';
import '/flavors/build_config.dart';
import '/flavors/env_config.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final EnvConfig _envConfig = BuildConfig.instance.config;
  Locale? _locale;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initLocale();
  }

  Future<void> _initLocale() async {
    String langCode;
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? lang= _prefs.getString('languageCode');
    if(lang==null){
      Locale deviceLocale = window.locale;
      langCode = deviceLocale.languageCode;
       setLocale(langCode);
    }else{
      langCode=lang;
    }
    List<Locale> supportedLanguages = _getSupportedLocal();
    if (supportedLanguages.contains(Locale(langCode))) {
      setState(() {
        _locale = Locale(langCode);
      });
    } else {
      setState(() {
        _locale = const Locale('en'); // Set English as the fallback locale
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [ SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: AppColors.pageBackground,
      ),
    );
    getLocale().then((value) {
      var platform = const MethodChannel('io.igrant.data4diabetes.channel');
      platform.invokeMethod('SetLanguage', {"code": value});
    });

    return GetMaterialApp(
      title: _envConfig.appName,
      initialRoute: AppPages.INITIAL,
      initialBinding: InitialBinding(),
      getPages: AppPages.routes,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      locale: _locale,
      supportedLocales: _getSupportedLocal(),
      theme: ThemeData(
        primarySwatch: AppColors.colorPrimarySwatch,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.light,
        primaryColor: AppColors.colorPrimary,
        textTheme: const TextTheme(
          button: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        fontFamily: 'Roboto',
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  List<Locale> _getSupportedLocal() {
    return [
      const Locale('en', ''),
      const Locale('sv', ''),
    ];
  }
}
