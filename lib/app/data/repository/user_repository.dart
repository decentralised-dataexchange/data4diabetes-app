
import '../model/login/LoginRequest.dart';
import '../model/login/LoginResponse.dart';

abstract class UserRepository {

  Future<LoginResponse> login(LoginRequest request);
}
