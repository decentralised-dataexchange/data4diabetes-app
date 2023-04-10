import 'package:get/get.dart';

import '/app/data/repository/user_repository.dart';
import '/app/data/repository/user_repository_impl.dart';

class RepositoryBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserRepository>(
      () => UserRepositoryImpl(),
      tag: (UserRepository).toString(),
    );
  }
}
