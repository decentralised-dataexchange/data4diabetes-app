import 'package:get/get.dart';

import '/app/data/remote/user_remote_data_source.dart';
import '/app/data/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remoteSource =
      Get.find(tag: (UserRemoteDataSource).toString());

}
