import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';

part 'customer.g.dart';

enum AccountStatus { active, inactive }

@Collection()
class Customer {
  String name;
  String phoneNumber;

  @Index(unique: true, replace: true)
  String uuId;

  Id? id;

  String description;

  double morningLtrsPref;

  double eveningLtrsPref;

  @enumerated
  AccountStatus status;

  Customer(this.name, this.phoneNumber, this.uuId, this.description,
      this.morningLtrsPref, this.eveningLtrsPref, this.status);

  Customer.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        phoneNumber = json['phone_number'],
        uuId = json['uuid'],
        description = json['description'],
        morningLtrsPref = checkDouble(json['pref_ltrs_morning']),
        eveningLtrsPref = checkDouble(json['pref_ltrs_evening']),
        status = AccountStatus.values.byName(json['status'] ?? 'active');

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'phone_number': phoneNumber,
        'uuid': uuId,
        'description': description,
        'pref_ltrs_morning': morningLtrsPref,
        'pref_ltrs_evening': eveningLtrsPref,
        'status': status.name
      };

  static double checkDouble(dynamic value) {
    if(value == null) return 0.0;
    if (value is String) {
      return double.parse(value);
    } else {
      return value.toDouble();
    }
  }
}
