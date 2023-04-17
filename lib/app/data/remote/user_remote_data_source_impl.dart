import 'package:Data4Diabetes/app/data/model/login/LoginRequest.dart';

import 'package:Data4Diabetes/app/data/model/login/LoginResponse.dart';

import '../../network/ApiEndPoints.dart';
import '../../network/dio_provider.dart';
import '/app/core/base/base_remote_source.dart';
import '/app/data/remote/user_remote_data_source.dart';

class UserRemoteDataSourceImpl extends BaseRemoteSource
    implements UserRemoteDataSource {
  @override
  Future<LoginResponse> login(LoginRequest request) {
    var endpoint = "${DioProvider.baseUrl}${ApiEndPoints.Login}";

    var dioCall = postWithJson(endpoint, data: request, isAuthNeeded: true);

    try {
      return callApiWithErrorParser(dioCall)
          .then((response) => LoginResponse.fromJson(response.data));
    } catch (e) {
      rethrow;
    }
  }

}
