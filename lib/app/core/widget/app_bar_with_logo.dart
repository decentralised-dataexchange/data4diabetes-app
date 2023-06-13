import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Constants/Palette.dart';
import '../../modules/settings/views/settings_view.dart';
class AppBarWithLogo extends StatelessWidget  implements PreferredSizeWidget {
  var title;
  AppBarWithLogo({Key? key,this.title}) : super(key: key);
  static const double toolbarHeight = 80;
  static const double circleContainerWidth = 50;
  static const double circleContainerHeight = 50;

  @override
  Size get preferredSize => AppBar().preferredSize;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: toolbarHeight,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Palette.white,
      title: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _appBarListTile(),
          const SizedBox(
            height: 8.0,
          ),
          const Divider(
            height: 2.0,
            thickness: 1,
          ),
        ],
      ),
    );
  }
  Widget _appBarListTile() {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      leading: Container(
        height: circleContainerHeight,
        width: circleContainerWidth,

        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),

        //backgroundImage: AssetImage('images/blood_drop.png'),
        child: Image.asset(
          'images/blood_drop.png',
          fit: BoxFit.cover,
        ),
      ),
      title: const Text(
        'Data4Diabetes',
        style: TextStyle(
            color: Color.fromARGB(255, 30, 189, 174),
            fontSize: 25,
            fontWeight: FontWeight.bold),
      ),
      subtitle: Text(title),
      trailing: IconButton(
        icon: const Icon(
          Icons.settings_outlined,
          color: Colors.blueGrey,
          size: 30,
        ),
        onPressed: () {
          Get.to(SettingsView());
        },
      ),
    );
  }


}
