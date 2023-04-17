class LoginResponse {
  String? msg;

  LoginResponse({this.msg});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;

    return data;
  }
}
