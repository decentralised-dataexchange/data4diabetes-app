class GlucoseData {
  String? referent;
  String? evgsValue;
  String? collectedDate;
  String? schemaId;
  String? credDefId;
  String? revRegId;
  String? credRevId;

  GlucoseData({
     this.referent,
     this.evgsValue,
     this.collectedDate,
     this.schemaId,
     this.credDefId,
     this.revRegId,
    this.credRevId,
  });

  factory GlucoseData.fromJson(Map<String, dynamic> json) {
    return GlucoseData(
      referent: json['referent']==null?null:json['referent'],
      evgsValue:json['attrs']['EVGS - Value']==null?null: json['attrs']['EVGS - Value'],
      collectedDate: json['attrs']['Collected Date']==null?null:json['attrs']['Collected Date'],
      schemaId: json['schema_id']==null?null:json['schema_id'],
      credDefId: json['cred_def_id']==null?null:json['cred_def_id'],
      revRegId: json['rev_reg_id']==null?null:json['rev_reg_id'],
      credRevId: json['cred_rev_id']==null?null:json['cred_rev_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'referent': referent,
      'attrs': {
        'EVGS - Value': evgsValue,
        'Collected Date': collectedDate,
      },
      'schema_id': schemaId,
      'cred_def_id': credDefId,
      'rev_reg_id': revRegId,
      'cred_rev_id': credRevId,
    };
  }
}
