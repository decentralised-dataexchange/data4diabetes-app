
class DeleteAccountResponse {
  String? msg;

  DeleteAccountResponse({
 this.msg,
  });

  factory DeleteAccountResponse.fromJson(Map<String, dynamic> json) => DeleteAccountResponse(
    msg: json["msg"]==null?null:json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "msg": msg==null?null:msg,
  };
}
