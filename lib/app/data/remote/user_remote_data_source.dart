import 'package:Data4Diabetes/app/data/model/dexcom/AccessTokenRequest.dart';
import 'package:Data4Diabetes/app/data/model/dexcom/AccessTokenResponse.dart';
import 'package:Data4Diabetes/app/data/model/dexcom/EstimatedGlucoseValue.dart';
import 'package:Data4Diabetes/app/data/model/dexcom/EstimatedGlucoseValueRequest.dart';
import 'package:Data4Diabetes/app/data/model/register/RegisterRequest.dart';
import 'package:Data4Diabetes/app/data/model/register/RegisterResponse.dart';
import 'package:Data4Diabetes/app/data/model/validateMobileNumber/ValidateMobileNumberRequest.dart';
import 'package:Data4Diabetes/app/data/model/validateMobileNumber/ValidateMobileNumberResponse.dart';
import 'package:Data4Diabetes/app/data/model/verifyOTP/VerifyOtpRequest.dart';
import 'package:Data4Diabetes/app/data/model/verifyOTP/VerifyOtpResponse.dart';

import '../model/deleteAccount/deleteAccountResponse.dart';
import '../model/login/LoginRequest.dart';
import '../model/login/LoginResponse.dart';

abstract class UserRemoteDataSource {
  Future<LoginResponse> login(LoginRequest request);
  Future<RegisterResponse> register(RegisterRequest request);
  Future<VerifyOtpResponse> verifyOTP(VerifyOtpRequest request);
  Future<ValidateMobileNumberResponse> validateMobileNumber(ValidateMobileNumberRequest request);
  Future<dynamic> deleteUserAccount();
  Future<AccessTokenResponse> obtainAccessToken(AccessTokenRequest request);
  Future<EstimatedGlucoseValue> evgs(EstimatedGlucoseValueRequest request);
}
