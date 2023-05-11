import 'package:get/get.dart';

import '/app/data/remote/user_remote_data_source.dart';
import '/app/data/remote/user_remote_data_source_impl.dart';

class RemoteSourceBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(),
      tag: (UserRemoteDataSource).toString(),
      fenix: true
    );
  }
}
