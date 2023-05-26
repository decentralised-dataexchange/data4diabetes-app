
import 'package:http/http.dart' as http;
import '../../flavors/build_config.dart';


class HttpProvider {
  static final String? baseUrl = BuildConfig.instance.config.baseUrl;

  Future<dynamic> deleteAccount(
      {required String url, required String token}) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl! + url),
        headers: {'Authorization': 'Bearer Token $token'},
      );

      return response.statusCode;
    } catch (e) {
      throw Exception(e);
    }
  }
}
