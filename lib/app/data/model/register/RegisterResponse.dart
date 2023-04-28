class RegisterResponse {
  String? msg;

  RegisterResponse({this.msg});

  RegisterResponse.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;

    return data;
  }
}
