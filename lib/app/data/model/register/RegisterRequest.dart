class RegisterRequest {
  String? firstname;
  String? lastname;
  String? mobile_number;

  RegisterRequest({this.firstname,this.lastname ,this.mobile_number});

  RegisterRequest.fromJson(Map<String, dynamic> json) {
    firstname=json['firstname'];
    lastname=json['lastname'];
    mobile_number = json['mobile_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstname']=this.firstname;
    data['lastname']=this.lastname;
    data['mobile_number'] = this.mobile_number;

    return data;
  }
}