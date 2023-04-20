import 'package:flutter/services.dart';
import 'package:get/get.dart';

class BottomNavController extends GetxController {

  var platform = MethodChannel('io.igrant.data4diabetes.channel');
  final _selectedIndexController = 0.obs;

  updateSelectedIndex(int index) => _selectedIndexController(index);

  int get selectedIndex => _selectedIndexController.value;
}
