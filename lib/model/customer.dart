class Customer {
  String name;
  String phoneNumber;
  String uuId;
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
