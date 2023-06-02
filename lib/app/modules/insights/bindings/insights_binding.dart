import 'package:Data4Diabetes/app/modules/insights/controllers/insights_controller.dart';
import 'package:Data4Diabetes/app/modules/language/controllers/language_controller.dart';
import 'package:get/get.dart';


class InsightsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InsightsController>(
          () => InsightsController(),
    );
  }
}
