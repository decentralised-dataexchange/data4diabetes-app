import 'package:flutter/material.dart';

import '../Constants/Palette.dart';
import '../Constants/app_text_files.dart';
import '../core/values/app_colors.dart';

class AppButton extends StatelessWidget {
  final String? text;
  final Function? onPressed;
  final bool isEnabled;
  final bool isCompact;
  final Color color;
  final Color textColor;
  final Widget? lefticon;
  final double? radius;
  final double radiusConst = 18.0;
  final double isCompactEnd = 12;
  final double fontSize = 16;

  const AppButton(
      {Key? key,
      @required this.text,
      @required this.onPressed,
      this.isEnabled = true,
      this.isCompact = false,
      this.color =  AppColors.colorAccent,
      this.textColor = Colors.white,
      this.lefticon,
      this.radius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (isEnabled) {
          onPressed!();
        }
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(color),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? radiusConst),
          ))),
      child: Padding(
        padding: EdgeInsets.all(isCompact ? 4 : isCompactEnd),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            lefticon ?? Container(),

            Text(
              text ?? '',
              style: AppTextStyles.normalText(
                  fontSize: fontSize, color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
