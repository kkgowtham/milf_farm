import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:milk_farm/date_utils.dart';
import 'package:milk_farm/isar_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'model/customer.dart';
import 'model/milk_data.dart';

class SupabaseHelper {
  static Future<dynamic> addOrUpdateMilkRecord(MilkRecord record) async {
    final result = await Supabase.instance.client
        .from('milk_records')
        .upsert(record.toJson(), onConflict: 'hashId');
    return result;
  }

  static Future addCustomer(Customer customer) async {
    final result = await Supabase.instance.client
        .from('customers')
        .upsert(customer.toJson(), onConflict: 'uuid');
    return result;
  }

  static Future<List<MilkRecord>> getRecordsForDate(String date) async {
    try {
      final List<Map<String, dynamic>> result = await Supabase.instance.client
          .from('milk_records')
          .select('*')
          .eq('date', date);
      final milkRecords = result.map((e) => MilkRecord.fromJson(e)).toList();
      return milkRecords;
    } catch (e) {
      return [];
    }
  }

  /// [month] - In Format MM-yyyy
  static Future<List<MilkRecord>> getRecordsForUser(
      String month, String uuid) async {
    try {
      final List<Map<String, dynamic>> result = await Supabase.instance.client
          .from('milk_records')
          .select('*')
          .eq('uuid', uuid)
          .in_('date', getDatesInMonth(month));
      final milkRecords = result.map((e) => MilkRecord.fromJson(e)).toList();
      return milkRecords;
    } catch (e) {
      return [];
    }
  }

  static List<String> getDatesInMonth(String date) {
    final dateTime = DateFormat("MM-yyyy").parse(date);
    final List<DateTime> dates = [];
    final firstDayOfMonth = DateTime(dateTime.year, dateTime.month);
    final lastDayOfMonth = DateTime(dateTime.year, dateTime.month + 1, 0);
    for (var i = firstDayOfMonth;
        i.isBefore(lastDayOfMonth.add(const Duration(days: 1)));
        i = i.add(const Duration(days: 1))) {
      dates.add(i);
    }
    return dates.map((e) => e.isoFormat).toList();
  }

  /// Format dd-MM-yyyy
  static Future<List<MilkRecord>> getRecordsForUserDate(
      DateTime date1, DateTime date2, String uuid) async {
    try {
      final List<dynamic> result = await Supabase.instance.client
          .from('milk_records')
          .select('*')
          .filter('date', 'in', getDatesForRange(date1, date2))
          .eq('uuid', uuid);
      debugPrint(result.toString());
      final milkRecords = result.map((e) => MilkRecord.fromJson(e)).toList();
      return milkRecords;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  static List<String> getDatesForRange(DateTime dateTime1, DateTime dateTime2) {
    final format = DateFormat("yyyy-MM-dd");
    final List<String> dates = [];
    for (DateTime date = dateTime1;
        date.isBefore(dateTime2);
        date = date.add(const Duration(days: 1))) {
      dates.add(date.isoFormat);
    }
    debugPrint(dates.toString());
    return dates;
  }

  static Future<void> fetchAndUpdateCustomers() async {
    Future.delayed(const Duration(milliseconds: 0), () async {
      final List<Map<String, dynamic>> result =
          await Supabase.instance.client.from('customers').select('*');
      for (int i = 0; i < result.length; i++) {
        IsarManager.addCustomer(Customer.fromJson(result[i]));
      }
    });
  }
}
