import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:milk_farm/isar_manager.dart';
import 'package:milk_farm/model/customer.dart';
import 'package:milk_farm/model/milk_data.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class RemoteManager {
  static void fetchAndUpdateCustomers() {
    Future.delayed(const Duration(milliseconds: 0), () {
      FirebaseFirestore.instance
          .collection('customer')
          .get()
          .then((data) async {
        for (int i = 0; i < data.docs.length; i++) {
          final custData = data.docs[i];
          final customer = Customer(custData['name'], custData['phoneNumber'],
              custData['uuid'], custData['description']);
          IsarManager.addCustomer(customer);
        }
      });
    });
  }

  static Future addCustomer(Customer customer) {
    return FirebaseFirestore.instance
        .collection("customer")
        .doc(customer.uuId)
        .set(customer.toJson());
  }

  static Future<dynamic> addOrUpdateMilkRecord(MilkRecord record) async{
    final result =  await FirebaseFirestore.instance
        .collection("milk_records")
        .doc(record.hashId)
        .set(record.toJson());
    return result;
  }


  static Future<QuerySnapshot<Map<String, dynamic>>> getMilkRecords(String date) {
    return FirebaseFirestore.instance
        .collection("milk_records")
        .where("date", isEqualTo: date)
        .get();
  }
}

