import 'package:Data4Diabetes/app/modules/launcher/controller/launcher_controller.dart';
import 'package:Data4Diabetes/app/modules/login/views/login_view.dart';
import 'package:Data4Diabetes/app/modules/main/views/main_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/local/preference/preference_manager_impl.dart';
import '/app/core/base/base_view.dart';

class LauncherView extends StatefulWidget {
  const LauncherView({Key? key}) : super(key: key);

  @override
  State<LauncherView> createState() => _LauncherViewState();
}

class _LauncherViewState extends State<LauncherView> {
  var isLogged;
  final PreferenceManagerImpl _preferenceManagerImpl=PreferenceManagerImpl();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:chooseScreen() ,
        builder:(BuildContext context,AsyncSnapshot snapshot){
          if(snapshot.hasData){
            return snapshot.data != "" ? MainView() : LoginView();
          }

          return SizedBox() ;
        });
  }

  Future chooseScreen() async{
    isLogged= await _preferenceManagerImpl.getString('token');
    print("logged value:"+isLogged);

    return isLogged;
  }
}

// class LauncherView extends BaseView<LauncherController> {
//   @override
//   PreferredSizeWidget? appBar(BuildContext context) {
//     return null;
//   }
//
//   final LauncherController _launcherController = Get.find();
//   @override
//   Widget body(BuildContext context) {
//    return FutureBuilder(
//      future:_launcherController.chooseScreen() ,
//        builder:(BuildContext context,AsyncSnapshot snapshot){
//      if(snapshot.hasData){
//        return snapshot.data != "" ? MainView() : LoginView();
//      }
//
//      return SizedBox() ;
//    });
//   }
// }
