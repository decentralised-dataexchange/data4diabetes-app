import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../flavors/build_config.dart';

const int statusCodeValue = 200;
const int invalidAccessToken = 401;

class HttpProvider {
  static final String? baseUrl = BuildConfig.instance.config.dexComBaseUrl;
  Future<dynamic> postData(String url, Map data) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl! + url),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: data,
      );

      if (response.statusCode == statusCodeValue) {
        print('POST request succeeded with response: ${response.body}');

        return json.decode(response.body.toString());
      } else {
        print('POST request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<dynamic> getEGVs(String accessToken,
      {String? startDate, String? endDate, String? url}) async {
    final uri = Uri.parse(baseUrl! + url!).replace(
      queryParameters: {
        if (startDate != null) 'startDate': startDate,
        if (endDate != null) 'endDate': endDate,
      },
    );
    print(uri);
    print('received accessToken:$accessToken');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    print('response_statuscode:${response.statusCode}');
    if (response.statusCode == statusCodeValue) {
      print('success section');
      final data = jsonDecode(response.body);

      return data;
    } else if (response.statusCode == invalidAccessToken) {
      print('401 section');

      return '401';
    } else {
      throw Exception('Failed to retrieve glucose values.');
    }
  }
}
