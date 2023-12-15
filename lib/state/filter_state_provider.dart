import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:milk_farm/date_utils.dart';
import 'package:milk_farm/isar_manager.dart';
import 'package:milk_farm/model/milk_data.dart';
import 'package:milk_farm/model/state/filter_state.dart';
import 'package:milk_farm/supabase_helper.dart';

class FilterStateProvider extends StateNotifier<FilterState> {
  FilterStateProvider()
      : super(const FilterState(isLoading: false, records: []));

  fetchData() async {
    state = state.copyWith(isLoading: true);
    fetchRemoteData();
    //fetchDataFromFireStore();
  }

  void fetchDataFromFireStore() async {
    final futures = <Future>[];
    getChunkedList().forEach((element) async {
      final data = FirebaseFirestore.instance
          .collection("milk_records")
          .where("uuid", isEqualTo: state.customer?.uuId ?? "")
          .where("date", whereIn: element);
      futures.add(data.get());
    });
    final querySnapshots = await Future.wait(futures);
    for (var querySnapshot in querySnapshots) {
      querySnapshot.docs.forEach((element) async {
        debugPrint("fetchDataFromFireStore(): ${element.data().toString()}");
        await IsarManager.isar?.writeTxn(() async {
          IsarManager.addOrUpdateMilkRecord(
              MilkRecord.fromJson(element.data()));
        });
      });
    }

    final records = <MilkRecord>[];
    for (var date in getAllDates()) {
      final data = IsarManager.isar?.milkRecords
          .filter()
          .uuidEqualTo(state.customer?.uuId ?? "")
          .dateEqualTo(date.isoFormat)
          .findAllSync();
      records.addAll(data ?? []);
    }

    for (var element in records) {
      debugPrint("fetchDataFromIsar(): ${element.toJson().toString()}");
    }
  }

  List<DateTime> getAllDates() {
    final startDate = state.fromDate;
    final endDate = state.toDate;
    if (startDate == null || endDate == null) return [];
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

  List<List<String>> getChunkedList() {
    return splitList(getAllDates(), 9)
        .map((e) => e.map((e) => e.isoFormat).toList())
        .toList();
  }

  List<List<T>> splitList<T>(List<T> list, int chunkSize) {
    final List<List<T>> chunks = [];
    for (var i = 0; i < list.length; i += chunkSize) {
      final end = (i + chunkSize < list.length) ? i + chunkSize : list.length;
      chunks.add(list.sublist(i, end));
    }
    return chunks;
  }

  void fetchRemoteData() {
    final fromDate = state.fromDate;
    if (fromDate == null) return;
    final toDate = state.toDate;
    if (toDate == null) return;
    final customerId = state.customer?.uuId;
    if (customerId == null) return;
    SupabaseHelper.getRecordsForUserDate(fromDate, toDate, customerId)
        .then((value) {
      IsarManager.addOrUpdateMilkRecords(value);
      state = state.copyWith(records: value, isLoading: false);
    }).catchError((data) {
      debugPrint(data.toString());
      state = state.copyWith(records: [], isLoading: false);
    });
  }
}

final filterStateProvider =
    StateNotifierProvider.autoDispose<FilterStateProvider, FilterState>(
        (ref) => FilterStateProvider());
