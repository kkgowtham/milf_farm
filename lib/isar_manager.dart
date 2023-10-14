import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'package:milk_farm/model/customer.dart';
import 'package:milk_farm/model/milk_data.dart';

class IsarManager {
  static Isar? isar;

  IsarManager();

  static void addCustomer(Customer customer) async {
    await isar?.writeTxn(() async {
      isar?.customers.put(customer);
    });
  }

  static Future<List<Customer>?> getCustomers() async {
    return isar?.customers.where().sortByName().findAll();
  }

  static List<Customer> getCustomersSync() {
    return isar?.customers.where().sortByName().findAllSync() ?? [];
  }

  static Future<dynamic> deleteAll() async {
    return await isar?.writeTxn(() async {
      return await isar?.customers.clear();
    });
  }

  static Customer? getCustomerById(String uuid) {
    return isar?.customers.filter().uuIdEqualTo(uuid).findFirstSync();
  }

  static List<MilkRecord> getMilkRecords(String date, Shift shift) {
    return isar?.milkRecords
            .filter()
            .dateEqualTo(date)
            .and()
            .shiftEqualTo(shift)
            .findAllSync() ??
        [];
  }

  static List<MilkRecord> getAllMilkRecords(String date, Shift shift) {
    final records = isar?.milkRecords
            .filter()
            .dateEqualTo(date)
            .and()
            .shiftEqualTo(shift)
            .findAllSync() ??
        [];
    final uuids = records.map((e) => e.uuid);
    final list = [
      ...getMilkRecords(date, shift),
      ...getCustomersSync()
          .where((element) => !uuids.contains(element.uuId))
          .map((e) => MilkRecord(
              uuid: e.uuId, shift: shift, date: date, totalLitres: 0))
          .toList()
    ];
    return list;
  }

  static void addOrUpdateRecord(MilkRecord record) {
    isar?.writeTxn(() async {
      isar?.milkRecords.put(record);
    });
  }

  static Future<Id>? addOrUpdateMilkRecord(MilkRecord record){
    return isar?.milkRecords.put(record);
  }
}
