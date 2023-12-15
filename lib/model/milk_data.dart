import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:isar/isar.dart';
import 'package:milk_farm/remote_manager.dart';

part 'milk_data.g.dart';

@Collection()
class MilkRecord {
  String uuid;
  @enumerated
  Shift shift;

  @Index(unique: true, replace: true)
  String get hashId {
    return getHashedString();
  }

  Id id = Isar.autoIncrement;

  /// Format - yyyy-MM-dd
  String date;
  double totalLitres;

  int timeStamp = -1;

  MilkRecord(
      {required this.uuid,
      required this.shift,
      required this.date,
      required this.totalLitres});

  Map<String, dynamic> toJson() {
    return {
      "uuid": uuid,
      "shift": shift.name.substring(0, 1),
      "date": date,
      "totalLitres": totalLitres,
      "hashId": hashId
    };
  }

  factory MilkRecord.fromJson(Map<String, dynamic> json) {
    return MilkRecord(
      uuid: json["uuid"],
      shift: Shift.values.firstWhere(
          (element) => element.name.startsWith(json["shift"].toString())),
      date: json["date"],
      totalLitres: double.parse(json["totalLitres"].toString()),
    );
  }

  String getHashedString() {
    final input = "$uuid^*${shift.name}^*$date";
    return md5.convert(utf8.encode(input)).toString();
  }
}

enum Shift {
  morning,
  evening;
}
