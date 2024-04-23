
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/preferred_size.dart';
import 'package:get/get.dart';

import '../../../Constants/Palette.dart';
import '../../../core/base/base_view.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/widget/app_bar_title.dart';
import '../../launcher/views/launcher_view.dart';
import '../controllers/credentials_controller.dart';

class CredentailsView extends BaseView<CredentialsController> {
  final CredentialsController _credentialsController = Get.find();
  static const double containerRaduis = 20;
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Palette.backgroundColor,
      //centerTitle: true,
      elevation: 0,
      automaticallyImplyLeading: true,
      leading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: const Icon(Icons.arrow_back_ios),
      ),
      iconTheme: const IconThemeData(color: AppColors.appBarIconColor),
      title: const AppBarTitle(text: 'Developer Options'),
    );
  }

  @override
  Widget body(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Palette.white,
                    border: Border.all(color: Palette.white),
                    borderRadius: const BorderRadius.all(
                        Radius.circular(containerRaduis))),
                child: Column(
                  children: [
                    _privacyDashboardCredWidget(),
                    const Divider(),
                    _dexcomCredWidget(),
                    const Divider(),
                    _deleteWallet(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _privacyDashboardCredWidget() {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -3),
      title: const Text(
        'Privacy Dashboard',
        style: TextStyle(
          fontSize: 14,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 15.0,
      ),
      onTap: () {
        // if (Platform.isAndroid) {

        _credentialsController.setPrivacyDashboardCred();
        // } else if (Platform.isIOS) {
        //   showToast('Coming soon');
        // }
      },
    );

  }

  _dexcomCredWidget() {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -3),
      title: const Text(
        'Dexcom',
        style: TextStyle(
          fontSize: 14,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 15.0,
      ),
      onTap: () {
        // if (Platform.isAndroid) {
        _credentialsController.setDexcomCred();
        // } else if (Platform.isIOS) {
        //   showToast('Coming soon');
        // }
      },
    );

  }

  _deleteWallet(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -3),
      title: const Text(
        'Delete Wallet',
        style: TextStyle(
          fontSize: 14,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 15.0,
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: const Text("Alert"),
              content: const Text("Do you want to delete your wallet?"),
              actions: [
                CupertinoDialogAction(
                  child: const Text("Yes"),
                  onPressed: () {
                    _credentialsController.deleteWallet();

                  },
                ),
                CupertinoDialogAction(
                  child: const Text("No"),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
