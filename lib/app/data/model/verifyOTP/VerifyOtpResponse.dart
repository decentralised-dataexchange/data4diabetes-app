
class VerifyOtpResponse {
  Data data;
  int status;

  VerifyOtpResponse({
    required this.data,
    required this.status,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) => VerifyOtpResponse(
    data: Data.fromJson(json["data"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
    "status": status,
  };
}

class Data {
  String token;
  String userId;
  String firstname;
  String lastname;

  Data({
    required this.token,
    required this.userId,
    required this.firstname,
    required this.lastname,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    token: json["token"],
    userId: json["user_id"],
    firstname: json["firstname"],
    lastname: json["lastname"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "user_id": userId,
    "firstname": firstname,
    "lastname": lastname,
  };
}