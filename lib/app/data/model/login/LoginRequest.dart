class LoginRequest {
  String? phonenumber;

  LoginRequest({this.phonenumber});

  LoginRequest.fromJson(Map<String, dynamic> json) {
    phonenumber = json['phonenumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phonenumber'] = this.phonenumber;

    return data;
  }
}