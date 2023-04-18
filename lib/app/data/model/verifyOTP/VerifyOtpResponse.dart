class VerifyOtpResponse {
  String? msg;
  String? token;
  String? user_id;
  String? firstname;
  String? lastname;

  VerifyOtpResponse({this.msg, this.token,this.lastname,this.firstname,this.user_id});

  VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    msg = json['msg'] == null ? null : json['msg'];
    token = json['token'] == null ? null : json['token'];
    user_id=json['user_id']==null?null:json['user_id'];
    firstname=json['firstname']==null?null:json['firstname'];
    lastname=json['lastname']==null?null:json['lastname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg == null ? null : this.msg;
    data['token'] = this.token == null ? null : this.token;
    data['user_id']=this.user_id==null?null:this.user_id;
    data['firstname']=this.firstname==null?null:this.firstname;
    data['lastname']=this.lastname==null?null:this.lastname;

    return data;
  }
}
