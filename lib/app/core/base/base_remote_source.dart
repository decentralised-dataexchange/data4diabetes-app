import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/local/preference/preference_manager_impl.dart';
import '/app/network/dio_provider.dart';
import '/app/network/error_handlers.dart';
import '/app/network/exceptions/base_exception.dart';
import '/flavors/build_config.dart';

abstract class BaseRemoteSource {
  Dio get dioClient => DioProvider.dioWithHeaderToken;

  final logger = BuildConfig.instance.config.logger;

  Future<Response<T>> callApiWithErrorParser<T>(Future<Response<T>> api) async {
    try {
      Response<T> response = await api;

      if (response.statusCode != HttpStatus.ok ||
          (response.data as Map<String, dynamic>)['statusCode'] !=
              HttpStatus.ok) {
        // TODO
      }
      debugPrint('received status: $response');

      return response;
    } on DioError catch (dioError) {
      Exception exception = handleDioError(dioError);
      logger.e(
          "Throwing error from repository: >>>>>>> $exception : ${(exception as BaseException).message}");
      throw exception;
    } catch (error) {
      logger.e("Generic error: >>>>>>> $error");

      if (error is BaseException) {
        rethrow;
      }

      throw handleError("$error");
    }
  }

  Future<Response<T>> postWithJson<T>(String path,
      {data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        bool isAuthNeeded = false}) async {
    final Map<String, String> headers = <String, String>{};
    if (isAuthNeeded) {
      var accessToken = await TokenRepository().getAccessToken();
      headers['Content-Type'] = 'application/json';
      headers['Authorization'] = 'Bearer Token $accessToken';
    }
    else{
      headers['Content-Type'] = 'application/json';
    }

    return dioClient.post(path, data: data, options: Options(headers: headers));
  }
}

class TokenRepository {
  getAccessToken()async{
    return await PreferenceManagerImpl().getString('token');
  }
}
