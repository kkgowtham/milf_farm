import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
part 'customer.g.dart';

@Collection()
class Customer {
  String name;
  String phoneNumber;

  @Index(unique: true,replace: true)
  String uuId;

  Id? id;

  String description;

  Customer(this.name, this.phoneNumber, this.uuId, this.description);

  Customer.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        phoneNumber = json['phoneNumber'],
        uuId = json['uuid'],
        description = json['description'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'phoneNumber': phoneNumber,
        'uuid': uuId,
        'description': description,
      };

}



