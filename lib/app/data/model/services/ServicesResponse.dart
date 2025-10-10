import 'dart:convert';

class ServicesResponse {
  List<DataDisclosureAgreementRecord>? records;

  ServicesResponse({this.records});

  ServicesResponse.fromJson(Map<String, dynamic> json) {
    if (json['dataDisclosureAgreementRecords'] != null) {
      records = <DataDisclosureAgreementRecord>[];
      json['dataDisclosureAgreementRecords'].forEach((v) {
        records!.add(DataDisclosureAgreementRecord.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (records != null) {
      data['dataDisclosureAgreementRecords'] =
          records!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataDisclosureAgreementRecord {
  String? name; // from dataController
  String? purpose;
  String? purposeDescription;
  String? logoUrl; // new field

  DataDisclosureAgreementRecord({
    this.name,
    this.purpose,
    this.purposeDescription,
    this.logoUrl,
  });

  DataDisclosureAgreementRecord.fromJson(Map<String, dynamic> json) {
    // Extract main objectData
    if (json['dataDisclosureAgreementTemplateRevision'] != null) {
      final objectDataStr =
      json['dataDisclosureAgreementTemplateRevision']['objectData'];
      if (objectDataStr != null) {
        final objectDataJson = jsonDecode(objectDataStr);
        name = objectDataJson['dataController']?['name'];
        purpose = objectDataJson['purpose'];
        purposeDescription = objectDataJson['purposeDescription'];
      }
    }

    // Extract logoUrl from signatureDecoded inside dataSourceSignature
    if (json['dataSourceSignature'] != null &&
        json['dataSourceSignature']['signatureDecoded'] != null) {
      final signatureDecoded = json['dataSourceSignature']['signatureDecoded'];
      if (signatureDecoded is Map<String, dynamic> &&
          signatureDecoded['logo_url'] != null) {
        logoUrl = signatureDecoded['logo_url'];
      }
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'purpose': purpose,
      'purposeDescription': purposeDescription,
      'logoUrl': logoUrl,
    };
  }
}
