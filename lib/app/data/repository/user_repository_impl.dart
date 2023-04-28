import 'package:Data4Diabetes/app/data/model/login/LoginRequest.dart';
import 'package:Data4Diabetes/app/data/model/login/LoginResponse.dart';
import 'package:Data4Diabetes/app/data/model/register/RegisterRequest.dart';
import 'package:Data4Diabetes/app/data/model/register/RegisterResponse.dart';
import 'package:Data4Diabetes/app/data/model/verifyOTP/VerifyOtpRequest.dart';
import 'package:Data4Diabetes/app/data/model/verifyOTP/VerifyOtpResponse.dart';
import 'package:get/get.dart';

import '/app/data/remote/user_remote_data_source.dart';
import '/app/data/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remoteSource =
      Get.find(tag: (UserRemoteDataSource).toString());
  /// Login
  @override
  Future<LoginResponse> login(LoginRequest request) {
    return _remoteSource.login(request);
  }
  /// Register
  @override
  Future<RegisterResponse> register(RegisterRequest request) {
    return _remoteSource.register(request);
  }
  /// Verify OTP
  @override
  Future<VerifyOtpResponse> verifyOTP(VerifyOtpRequest request) {
    return _remoteSource.verifyOTP(request);
  }
}
