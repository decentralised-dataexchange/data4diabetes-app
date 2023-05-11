import 'package:Data4Diabetes/app/modules/scan_and_check/views/scanAndCheck_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/app/core/base/base_view.dart';
import '/app/modules/home/views/home_view.dart';
import '/app/modules/main/controllers/main_controller.dart';
import '/app/modules/main/model/menu_code.dart';
import '/app/modules/main/views/bottom_nav_bar.dart';

class MainView extends BaseView<MainController> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) {

    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Container(
      key: UniqueKey(),
      child: Obx(() => getPageOnSelectedMenu(controller.selectedMenuCode)),
    );
  }

  @override
  Widget? bottomNavigationBar() {

    return BottomNavBar(onNewMenuSelected: controller.onMenuSelected);
  }

  final HomeView homeView = HomeView();
  final ScanAndCheckView scanAndCheckView = ScanAndCheckView();

  Widget getPageOnSelectedMenu(MenuCode menuCode) {
    switch (menuCode) {
      case MenuCode.HOME:
        return homeView;
      case MenuCode.MYWALLET:
        return homeView;
      case MenuCode.INSIGHTS:
        return homeView;
      case MenuCode.SCAN_AND_CHECK:
        return scanAndCheckView;
    }
  }
}
