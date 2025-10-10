
class ServicesRequest {
  int? offset;
  int? limit;
  String? organisationRole;
  String? signStatus;

  ServicesRequest({this.offset, this.limit, this.organisationRole,this.signStatus});

  ServicesRequest.fromJson(Map<String, dynamic> json) {
    offset = json['offset'];
    limit = json['limit'];
    organisationRole = json['organisationRole'];
    signStatus = json['signStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['offset'] = this.offset;
    data['limit'] = this.limit;
    data['organisationRole'] = this.organisationRole;
    data['signStatus'] = this.signStatus;
    return data;
  }
}
