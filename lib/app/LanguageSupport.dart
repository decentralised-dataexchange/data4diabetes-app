import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String LAGUAGE_CODE = 'languageCode';

Future<String> setLocale(String languageCode) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(LAGUAGE_CODE, languageCode);
  var platform = const MethodChannel('io.igrant.data4diabetes.channel');
  platform.invokeMethod('SetLanguage', {
    "code": languageCode
  });
  return languageCode;
}

Future<String> getLocale() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String languageCode = _prefs.getString(LAGUAGE_CODE) ?? "en";

  return languageCode;
}

const String ENGLISH = 'en';
const String SWEDISH = 'sv';

Locale _locale(String languageCode) {
  switch (languageCode) {
    case ENGLISH:
      return Locale(ENGLISH, 'US');
    case SWEDISH:
      return Locale(SWEDISH, "SV");
    default:
      return Locale(ENGLISH, 'US');
  }
}
