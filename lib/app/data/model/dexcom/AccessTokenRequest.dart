class AccessTokenRequest {
  String? clientID;
  String? clientSecret;
  String? code;
  String? grantType;
  String? redirectUri;

  AccessTokenRequest(
      {this.clientID,
      this.clientSecret,
      this.redirectUri,
      this.code,
      this.grantType});

  AccessTokenRequest.fromJson(Map<String, dynamic> json) {
    clientID = json['client_id'];
    clientSecret = json['client_secret'];
    code = json['code'];
    grantType = json['grant_type'];
    redirectUri = json['redirect_uri'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['client_id'] = this.clientID;
    data['client_secret'] =this. clientSecret;
    data['code'] = this.code;
    data['grant_type'] = this.grantType;
    data['redirect_uri'] = this.redirectUri;

    return data;
  }
}
