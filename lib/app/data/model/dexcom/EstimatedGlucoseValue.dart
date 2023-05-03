
class EstimatedGlucoseValue {
  String? recordType;
  String? recordVersion;
  String? userId;
  List<Record>? records;

  EstimatedGlucoseValue({
  this.recordType,
     this.recordVersion,
   this.userId,
    this.records,
  });

  factory EstimatedGlucoseValue.fromJson(Map<String, dynamic> json) => EstimatedGlucoseValue(
    recordType: json["recordType"]==null?null:json["recordType"],
    recordVersion: json["recordVersion"]==null?null:json["recordVersion"],
    userId: json["userId"]==null?null:json["userId"],
    records:json["records"]==null?null: List<Record>.from(json["records"].map((x) => Record.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "recordType": recordType==null?null:recordType,
    "recordVersion": recordVersion==null?null:recordVersion,
    "userId": userId==null?null:userId,
    "records": List<dynamic>.from(records!.map((x) => x.toJson())),
  };
}

class Record {
  String? recordId;
  String? systemTime;
  DateTime? displayTime;
  TransmitterId? transmitterId;
  int? transmitterTicks;
  int? value;
  Trend? trend;
  double? trendRate;
  Unit? unit;
  RateUnit? rateUnit;
  DisplayDevice? displayDevice;
  TransmitterGeneration? transmitterGeneration;

  Record({
this.recordId,
this.systemTime,
   this.displayTime,
 this.transmitterId,
  this.transmitterTicks,
this.value,
this.trend,
   this.trendRate,
    this.unit,
    this.rateUnit,
  this.displayDevice,
   this.transmitterGeneration,
  });

  factory Record.fromJson(Map<String, dynamic> json) => Record(
    recordId: json["recordId"]==null?null:json["recordId"],
    systemTime: json["systemTime"]==null?null:json["systemTime"],
    displayTime:json["displayTime"]==null?null: DateTime.parse(json["displayTime"]),
    transmitterId: json["transmitterId"]==null?null:transmitterIdValues.map[json["transmitterId"]],
    transmitterTicks:json["transmitterTicks"]==null?null: json["transmitterTicks"],
    value: json["value"]==null?null:json["value"],
    trend:json["trend"]==null?null: trendValues.map[json["trend"]],
    trendRate: json["trendRate"]==null?null:json["trendRate"],
    unit: json["unit"]==null?null:unitValues.map[json["unit"]],
    rateUnit:json["rateUnit"]==null?null: rateUnitValues.map[json["rateUnit"]],
    displayDevice:json["displayDevice"]==null?null: displayDeviceValues.map[json["displayDevice"]],
    transmitterGeneration:json["transmitterGeneration"]==null?null: transmitterGenerationValues.map[json["transmitterGeneration"]],
  );

  Map<String, dynamic> toJson() => {
    "recordId": recordId,
    "systemTime": systemTime,
    "displayTime": displayTime?.toIso8601String(),
    "transmitterId": transmitterIdValues.reverse[transmitterId],
    "transmitterTicks": transmitterTicks,
    "value": value,
    "trend": trendValues.reverse[trend],
    "trendRate": trendRate,
    "unit": unitValues.reverse[unit],
    "rateUnit": rateUnitValues.reverse[rateUnit],
    "displayDevice": displayDeviceValues.reverse[displayDevice],
    "transmitterGeneration": transmitterGenerationValues.reverse[transmitterGeneration],
  };
}

enum DisplayDevice { RECEIVER }

final displayDeviceValues = EnumValues({
  "receiver": DisplayDevice.RECEIVER
});

enum RateUnit { MG_D_L_MIN }

final rateUnitValues = EnumValues({
  "mg/dL/min": RateUnit.MG_D_L_MIN
});

enum TransmitterGeneration { G4 }

final transmitterGenerationValues = EnumValues({
  "g4": TransmitterGeneration.G4
});

enum TransmitterId { THE_4_A5_D38_D5_E74719_B207282_E1_E8759_DCB75_AB3372_A7523_ADB3_E057_A8_F9774_BC6_F6 }

final transmitterIdValues = EnumValues({
  "4a5d38d5e74719b207282e1e8759dcb75ab3372a7523adb3e057a8f9774bc6f6": TransmitterId.THE_4_A5_D38_D5_E74719_B207282_E1_E8759_DCB75_AB3372_A7523_ADB3_E057_A8_F9774_BC6_F6
});

enum Trend { FLAT, FORTY_FIVE_DOWN, SINGLE_DOWN, FORTY_FIVE_UP, SINGLE_UP, NOT_COMPUTABLE, DOUBLE_DOWN, DOUBLE_UP }

final trendValues = EnumValues({
  "doubleDown": Trend.DOUBLE_DOWN,
  "doubleUp": Trend.DOUBLE_UP,
  "flat": Trend.FLAT,
  "fortyFiveDown": Trend.FORTY_FIVE_DOWN,
  "fortyFiveUp": Trend.FORTY_FIVE_UP,
  "notComputable": Trend.NOT_COMPUTABLE,
  "singleDown": Trend.SINGLE_DOWN,
  "singleUp": Trend.SINGLE_UP
});

enum Unit { MG_D_L }

final unitValues = EnumValues({
  "mg/dL": Unit.MG_D_L
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));

    return reverseMap;
  }
}
