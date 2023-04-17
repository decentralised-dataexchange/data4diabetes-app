import '../model/login/LoginRequest.dart';
import '../model/login/LoginResponse.dart';

abstract class UserRemoteDataSource {
  Future<LoginResponse> login(LoginRequest request);
}
