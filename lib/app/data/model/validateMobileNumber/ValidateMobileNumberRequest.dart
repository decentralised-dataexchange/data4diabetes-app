class ValidateMobileNumberRequest {
  String? mobile_number;

  ValidateMobileNumberRequest({this.mobile_number});

  ValidateMobileNumberRequest.fromJson(Map<String, dynamic> json) {
    mobile_number = json['mobile_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mobile_number'] = this.mobile_number;

    return data;
  }
}