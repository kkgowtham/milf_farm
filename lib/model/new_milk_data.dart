import 'dart:convert';

import 'package:crypto/crypto.dart';

class NewMilkData {
  String date;
  List<NewMilkRecord> morningData;
  List<NewMilkRecord> eveningData;

  String get hashId {
    return md5.convert(utf8.encode(date)).toString();
  }

  NewMilkData(
      {required this.date,
      required this.morningData,
      required this.eveningData});

  factory NewMilkData.fromJson(Map<String, dynamic> json) {
    return NewMilkData(
      date: json["date"],
      morningData: List.of(json["morning"])
          .map((i) => NewMilkRecord.fromJson(i))
          .toList(),
      eveningData: List.of(json["evening"])
          .map((i) => NewMilkRecord.fromJson(i))
          .toList(),
    );
  }
}

class NewMilkRecord {
  double uuid;
  double totalLitres;

  NewMilkRecord({required this.uuid, required this.totalLitres});

  factory NewMilkRecord.fromJson(Map<String, dynamic> json) {
    return NewMilkRecord(
      uuid: double.parse(json["uuid"]),
      totalLitres: double.parse(json["totalLitres"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uuid": uuid,
      "totalLitres": totalLitres,
    };
  }
}
