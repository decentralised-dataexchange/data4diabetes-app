import 'package:Data4Diabetes/app/data/model/deleteAccount/deleteAccountResponse.dart';
import 'package:Data4Diabetes/app/data/model/login/LoginRequest.dart';

import 'package:Data4Diabetes/app/data/model/login/LoginResponse.dart';
import 'package:Data4Diabetes/app/data/model/register/RegisterRequest.dart';
import 'package:Data4Diabetes/app/data/model/register/RegisterResponse.dart';
import 'package:Data4Diabetes/app/data/model/validateMobileNumber/ValidateMobileNumberResponse.dart';
import 'package:Data4Diabetes/app/data/model/verifyOTP/VerifyOtpRequest.dart';
import 'package:Data4Diabetes/app/data/model/verifyOTP/VerifyOtpResponse.dart';
import 'package:dio/dio.dart';

import '../../network/ApiEndPoints.dart';
import '../../network/dio_provider.dart';
import '../model/validateMobileNumber/ValidateMobileNumberRequest.dart';
import '/app/core/base/base_remote_source.dart';
import '/app/data/remote/user_remote_data_source.dart';

class UserRemoteDataSourceImpl extends BaseRemoteSource
    implements UserRemoteDataSource {
  ///Login
  @override
  Future<LoginResponse> login(LoginRequest request) {
    var endpoint = "${DioProvider.baseUrl}${ApiEndPoints.Login}";

    var dioCall = postWithJson(endpoint, data: request, isAuthNeeded: false);

    try {
      return callApiWithErrorParser(dioCall)
          .then((response) => LoginResponse.fromJson(response.data));
    } catch (e) {
      rethrow;
    }
  }
  /// Register
  @override
  Future<RegisterResponse> register(RegisterRequest request) {
    var endpoint = "${DioProvider.baseUrl}${ApiEndPoints.Register}";

    var dioCall = postWithJson(endpoint, data: request, isAuthNeeded: false);

    try {
      return callApiWithErrorParser(dioCall)
          .then((response) => RegisterResponse.fromJson(response.data));
    } catch (e) {
      rethrow;
    }
  }
  /// Verify OTP
  @override
  Future<VerifyOtpResponse> verifyOTP(VerifyOtpRequest request) {
    var endpoint = "${DioProvider.baseUrl}${ApiEndPoints.VerifyOTP}";

    var dioCall = postWithJson(endpoint, data: request, isAuthNeeded: false);

    try {
      return callApiWithErrorParser(dioCall)
          .then((response) => VerifyOtpResponse.fromJson(response.data));
    } catch (e) {
      rethrow;
    }
  }
  /// Validate mobile number
  @override
  Future<ValidateMobileNumberResponse> validateMobileNumber(ValidateMobileNumberRequest request) {
    var endpoint = "${DioProvider.baseUrl}${ApiEndPoints.ValidateMobileNumber}";

    var dioCall = postWithJson(endpoint, data: request, isAuthNeeded: false);

    try {
      return callApiWithErrorParser(dioCall)
          .then((response) => ValidateMobileNumberResponse.fromJson(response.data));
    } catch (e) {
      rethrow;
    }
  }
  /// delete user account
  @override
  Future<dynamic> deleteUserAccount() {
    var endpoint = "${DioProvider.baseUrl}${ApiEndPoints.deleteAccount}";

    var dioCall = postWithJson(endpoint,isAuthNeeded: true);

    try {
      return callApiWithErrorParser(dioCall)
          .then((response) => response.statusCode);
    } catch (e) {
      rethrow;
    }
  }

}
