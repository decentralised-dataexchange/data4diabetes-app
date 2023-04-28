class VerifyOtpResponse {
  String token;
  String userId;
  String firstname;
  String lastname;

  VerifyOtpResponse({
    required this.token,
    required this.userId,
    required this.firstname,
    required this.lastname,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) => VerifyOtpResponse(
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
