import 'package:Data4Diabetes/app/Constants/Palette.dart';
import 'package:Data4Diabetes/app/utility/screen_utility_num_extension..dart';
import 'package:flutter/material.dart';

enum FontType { Thin, Regular, Bold }

class AppTextStyles {
  static const double headingSize = 16;
  static const double normalTextSize = 14;
  static const double pageTitleSize = 18;
  static const double size = 14.0;

  static FontWeight fontType(FontType fontType) {
    if (fontType == FontType.Bold) {
      return FontWeight.w700;
    } else if (fontType == FontType.Thin) {
      return FontWeight.w300;
    } else if (fontType == FontType.Regular) {
      return FontWeight.w400;
    } else {
      return FontWeight.w400;
    }
  }

  static TextStyle textStyle(
      {FontType fontType = FontType.Regular,
      Color color = Colors.white,
      double size = size,
      FontWeight fontWeight = FontWeight.normal}) {
    return TextStyle(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.normal,
      // fontFamily: 'Roboto'
    );
  }

  static TextStyle boldTextStyle(
      {FontType fontType = FontType.Regular,
      Color color = Colors.white,
      double size = size,
      FontWeight fontWeight = FontWeight.normal}) {
    return TextStyle(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.bold,
      // fontFamily: 'Roboto'
    );
  }

  static TextStyle underLineTextStyle(
      {FontType fontType = FontType.Regular,
      Color color = Colors.white,
      double size = size,
      FontWeight fontWeight = FontWeight.normal}) {
    return TextStyle(
      color: color,
      fontSize: size,
      fontWeight: AppTextStyles.fontType(fontType),
      fontFamily: 'Lato',
      decoration: TextDecoration.underline,
    );
  }

  ///USE THIS STYLES ONLY/////
  static TextStyle normalText({
    Color color = Palette.textColor,
    double? fontSize,
  }) =>
      AppTextStyles.textStyle(
          size: fontSize ?? normalTextSize.f,
          color: color,
          fontType: FontType.Regular);

  static TextStyle thinText({
    Color color = Palette.textColor,
    double? fontSize,
  }) =>
      AppTextStyles.textStyle(
          size: fontSize ?? normalTextSize.f,
          color: color,
          fontType: FontType.Thin);

  static TextStyle boldText({
    Color color = Palette.textColor,
    double? fontSize,
  }) =>
      AppTextStyles.boldTextStyle(
          size: fontSize ?? normalTextSize,
          color: color,
          fontType: FontType.Bold);
}
