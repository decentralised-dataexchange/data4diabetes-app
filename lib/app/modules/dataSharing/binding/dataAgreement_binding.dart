
import 'package:Data4Diabetes/app/modules/dataSharing/controllers/dataAgreement_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

class DataAgreementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DataAgreementContoller>(
          () => DataAgreementContoller(),
      fenix: true,
    );


  }
}