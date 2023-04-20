import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '/app/core/values/app_colors.dart';
import '/app/core/values/app_values.dart';
import '/app/modules/main/controllers/bottom_nav_controller.dart';
import '/app/modules/main/model/menu_code.dart';
import '/app/modules/main/model/menu_item.dart';

// ignore: must_be_immutable
class BottomNavBar extends StatelessWidget {
  final Function(MenuCode menuCode) onNewMenuSelected;

  BottomNavBar({Key? key, required this.onNewMenuSelected}) : super(key: key);
  late AppLocalizations appLocalization;

  final navController = BottomNavController();

  final Key bottomNavKey = GlobalKey();

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
        onTap: (index) {
          if(index==1 || index == 2){
            navController.platform.invokeMethod('Connections');

            return;
          }
          else{
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
          navTitle: appLocalization.bottomNavConnections,
          iconSvgName: "ic_share.svg",
          menuCode: MenuCode.CONNECTIONS),
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
