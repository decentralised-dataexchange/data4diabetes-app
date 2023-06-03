import 'package:Data4Diabetes/app/Constants/Palette.dart';
import 'package:flutter/material.dart';

import '/app/core/values/app_colors.dart';
import '/app/core/widget/app_bar_title.dart';

//Default appbar customized with the design of our app
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String appBarTitleText;
  final Color? backgroundColor;
  final List<Widget>? actions;
  final bool isBackButtonEnabled;

  CustomAppBar({
    Key? key,
    required this.appBarTitleText,
    this.actions,
    this.backgroundColor,
    this.isBackButtonEnabled = true,

  }) : super(key: key);

  @override
  Size get preferredSize => AppBar().preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
     // backgroundColor: AppColors.appBarColor,
      backgroundColor:backgroundColor?? Palette.backgroundColor,
      //centerTitle: true,
      elevation: 0,
      automaticallyImplyLeading: isBackButtonEnabled,
      actions: actions,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios),
      ),
      iconTheme: const IconThemeData(color: AppColors.appBarIconColor),
      title: AppBarTitle(text: appBarTitleText),
    );
  }
}
