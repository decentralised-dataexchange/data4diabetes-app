class ValidateMobileNumberResponse {
  bool? isValidMobileNumber;

  ValidateMobileNumberResponse({
     this.isValidMobileNumber,
  });

  factory ValidateMobileNumberResponse.fromJson(Map<String, dynamic> json) => ValidateMobileNumberResponse(
    isValidMobileNumber: json["is_valid_mobile_number"]==null?null:json["is_valid_mobile_number"],
  );

  Map<String, dynamic> toJson() => {
    "is_valid_mobile_number": isValidMobileNumber==null?null:isValidMobileNumber,
  };
}