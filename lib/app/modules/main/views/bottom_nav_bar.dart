import 'package:Data4Diabetes/app/modules/insights/controllers/insights_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '/app/core/values/app_colors.dart';
import '/app/core/values/app_values.dart';
import '/app/modules/main/controllers/bottom_nav_controller.dart';
import '/app/modules/main/model/menu_code.dart';
import '/app/modules/main/model/menu_item.dart';
import 'dart:io' show Platform;

// ignore: must_be_immutable
class BottomNavBar extends StatelessWidget {
  final Function(MenuCode menuCode) onNewMenuSelected;

  BottomNavBar({Key? key, required this.onNewMenuSelected}) : super(key: key);
  late AppLocalizations appLocalization;

  final navController = BottomNavController();

  final Key bottomNavKey = GlobalKey();
  final InsightsController _insightsController = Get.find();
  @override
  Widget build(BuildContext context) {
    appLocalization = AppLocalizations.of(context)!;

    Color selectedItemColor = AppColors.colorAccent;
    Color unselectedItemColor = Colors.black;
    List<BottomNavItem> navItems = _getNavItems();

    return Obx(
      () => BottomNavigationBar(
        key: bottomNavKey,
        items: navItems
            .map(
              (BottomNavItem navItem) => BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "images/${navItem.iconSvgName}",
                    height: AppValues.iconDefaultSize,
                    width: AppValues.iconDefaultSize,
                    color:
                        navItems.indexOf(navItem) == navController.selectedIndex
                            ? selectedItemColor
                            : unselectedItemColor,
                  ),
                  label: navItem.navTitle,
                  tooltip: ""),
            )
            .toList(),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.pageBackground,
        selectedItemColor: selectedItemColor,
        unselectedItemColor: unselectedItemColor,
        currentIndex: navController.selectedIndex,
        onTap: (index) async {
          if (index == 1) {
            // if (Platform.isAndroid) {
              navController.platform.invokeMethod('Wallet');
            // } else if (Platform.isIOS) {
            //   Fluttertoast.showToast(
            //       msg: 'coming soon',
            //       toastLength: Toast.LENGTH_SHORT,
            //       timeInSecForIosWeb: 1);
            // }
          }
          if (index == 2) {
             _insightsController.estimatedGlucoseValues();
            _insightsController.gMICalculator(
                _insightsController.selectedValue.value = 'TODAY');
            _insightsController.tIRCalculator(
                _insightsController.selectedValue.value = 'TODAY');
            _insightsController.addChartDataValues(
                _insightsController.selectedValue.value = 'TODAY');
            navController.updateSelectedIndex(index);
            onNewMenuSelected(navItems[index].menuCode);
          } else {
            navController.updateSelectedIndex(index);
            onNewMenuSelected(navItems[index].menuCode);
          }
        },
      ),
    );
  }

  List<BottomNavItem> _getNavItems() {
    return [
      BottomNavItem(
        navTitle: appLocalization.bottomNavHome,
        iconSvgName: "ic_home.svg",
        menuCode: MenuCode.HOME,
      ),
      BottomNavItem(
          navTitle: appLocalization.bottomNavMyWallet,
          iconSvgName: "ic_mywallet.svg",
          menuCode: MenuCode.MYWALLET),
      BottomNavItem(
          navTitle: appLocalization.bottomNavInsights,
          iconSvgName: "ic_insights.svg",
          menuCode: MenuCode.INSIGHTS),
      BottomNavItem(
          navTitle: appLocalization.bottomNavScanAndCheck,
          iconSvgName: "ic_check_circle_outline.svg",
          menuCode: MenuCode.SCAN_AND_CHECK)
    ];
  }
}
