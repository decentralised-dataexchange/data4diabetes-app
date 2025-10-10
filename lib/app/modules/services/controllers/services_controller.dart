import 'package:Data4Diabetes/app/data/model/services/ServicesResponse.dart';
import '../../../data/model/services/ServicesRequest.dart';
import '../../../data/repository/user_repository_impl.dart';
import '/app/core/base/base_controller.dart';
import 'package:get/get.dart';


class ServicesController extends BaseController {
  final UserRepositoryImpl _impl = UserRepositoryImpl();
  var isLoading = false.obs;
  // Reactive list to hold services for UI
  var servicesList = <DataDisclosureAgreementRecord>[].obs;

  void getServices() async {
    //showLoading();
    isLoading.value = true;
    ServicesRequest request = ServicesRequest(
      limit: 10,
      offset: 0,
      organisationRole: "data_using_service",
      signStatus: "signed"
    );

    try {
      ServicesResponse response = await _impl.services(request);
      // Populate the observable list safely with null check
      if (response.records != null && response.records!.isNotEmpty) {
        servicesList.assignAll(response.records ?? []);
      } else {
        servicesList.clear();
      }

    } catch (e) {
      GetSnackToast(message: e.toString());
    } finally {
     // hideLoading();
      isLoading.value = false;
    }
  }
}


