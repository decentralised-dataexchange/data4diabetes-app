class AccessTokenResponse {
  String? accessToken;
  String? refreshToken;
  int? expiresIn;
  String? tokenType;

  AccessTokenResponse({
  this.accessToken,
     this.refreshToken,
    this.expiresIn,
    this.tokenType,
  });

  factory AccessTokenResponse.fromJson(Map<String, dynamic> json) =>
      AccessTokenResponse(
        accessToken: json["access_token"]==null?null:json["access_token"],
        refreshToken: json["refresh_token"]==null?null:json["refresh_token"],
        expiresIn: json["expires_in"]==null?null:json["expires_in"],
        tokenType: json["token_type"]==null?null:json["token_type"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken==null?null: accessToken,
        "refresh_token": refreshToken==null?null:refreshToken,
        "expires_in": expiresIn==null?null:expiresIn,
        "token_type": tokenType==null?null:tokenType,
      };
}
