import 'package:Data4Diabetes/app/data/model/deleteAccount/deleteAccountRequest.dart';
import 'package:Data4Diabetes/app/data/model/deleteAccount/deleteAccountResponse.dart';
import 'package:Data4Diabetes/app/data/model/dexcom/AccessTokenRequest.dart';
import 'package:Data4Diabetes/app/data/model/dexcom/EstimatedGlucoseValue.dart';
import 'package:Data4Diabetes/app/data/model/dexcom/EstimatedGlucoseValueRequest.dart';
import 'package:Data4Diabetes/app/data/model/login/LoginRequest.dart';

import 'package:Data4Diabetes/app/data/model/login/LoginResponse.dart';
import 'package:Data4Diabetes/app/data/model/register/RegisterRequest.dart';
import 'package:Data4Diabetes/app/data/model/register/RegisterResponse.dart';
import 'package:Data4Diabetes/app/data/model/validateMobileNumber/ValidateMobileNumberResponse.dart';
import 'package:Data4Diabetes/app/data/model/verifyOTP/VerifyOtpRequest.dart';
import 'package:Data4Diabetes/app/data/model/verifyOTP/VerifyOtpResponse.dart';
import 'package:dio/dio.dart';

import '../../../flavors/build_config.dart';
import '../../network/ApiEndPoints.dart';
import '../../network/dio_provider.dart';
import '../model/dexcom/AccessTokenResponse.dart';
import '../model/validateMobileNumber/ValidateMobileNumberRequest.dart';
import '/app/core/base/base_remote_source.dart';
import '/app/data/remote/user_remote_data_source.dart';

class UserRemoteDataSourceImpl extends BaseRemoteSource
    implements UserRemoteDataSource {
  static final String? dexComBaseUrl = BuildConfig.instance.config.dexComBaseUrl;
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
  Future<dynamic> deleteUserAccount(DeleteAccountRequest request) {
    var endpoint = "${DioProvider.baseUrl}${ApiEndPoints.deleteAccount}";

    var dioCall = postWithJson(endpoint,data: request, isAuthNeeded: true);

    try {
      return callApiWithErrorParser(dioCall)
          .then((response) => response.statusCode);
    } catch (e) {
      rethrow;
    }
  }
  /// obtain dexcom Access Token
  @override
  Future<AccessTokenResponse> obtainAccessToken(AccessTokenRequest request) {
    var endpoint = "$dexComBaseUrl${ApiEndPoints.dexcomAccessToken}";

    var dioCall = postDexcom(endpoint, data: request,isAuthNeeded: false,options: Options(
      headers: {
        'Content-Type':'application/x-www-form-urlencoded',
      }
    ));

    try {
      return callApiWithErrorParser(dioCall)
          .then((response) => AccessTokenResponse.fromJson(response.data));
    } catch (e) {
      rethrow;
    }
  }

  /// estimated glucose values
  @override
  Future<EstimatedGlucoseValue> evgs(EstimatedGlucoseValueRequest request) {
    var endpoint = "$dexComBaseUrl${ApiEndPoints.dexcomEVGS}";

    var dioCall = getDexcom(endpoint,
        isAuthNeeded: true,
        options: Options(
          headers: {
            'Authorization':'Bearer ${request.accessToken}'
          }
        ),
        queryParameters: {
      'startDate':request.startDate,
      'endDate':request.endDate
    });

    try {
      return callApiWithErrorParser(dioCall)
          .then((response) => EstimatedGlucoseValue.fromJson(response.data));
    } catch (e) {
      rethrow;
    }
  }
}
