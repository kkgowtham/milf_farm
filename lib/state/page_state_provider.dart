import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:milk_farm/isar_manager.dart';
import 'package:milk_farm/model/milk_data.dart';
import 'package:milk_farm/model/state/page_state.dart';
import 'package:milk_farm/supabase_helper.dart';

class PageStateProvider extends StateNotifier<PageState> {
  PageStateProvider(String date)
      : super(PageState(
            date: date,
            shift: Shift.morning,
            records: IsarManager.getMilkRecordsData(date, Shift.morning),
            isLoading: true,
            preferenceRecords:
                IsarManager.getPreferenceMilkRecords(date, Shift.morning)));

  onDateChanged(String date) {
    state = state.copyWith(
        date: date,
        shift: Shift.morning,
        isLoading: false,
        records: getMilkRecords(state.date, Shift.morning),
        preferenceRecords:
            IsarManager.getPreferenceMilkRecords(state.date, Shift.morning));
  }

  onShiftChanged(Shift shift) {
    debugPrint(shift.toString());
    state = state.copyWith(
        shift: shift, records: getMilkRecords(state.date, shift),
        preferenceRecords:
        IsarManager.getPreferenceMilkRecords(state.date, shift)
    );
  }

  void updateMilkRecord(
      MilkRecord record, double totalLitres, Function callback) async {
    record.totalLitres = totalLitres;
    addMilkRecord(record, callback);
  }

  void addMilkRecord(MilkRecord record, Function callback) async {
    try {
      record.timeStamp = DateTime.now().millisecondsSinceEpoch;
      await SupabaseHelper.addOrUpdateMilkRecord(record);
      await IsarManager.isar?.writeTxn(() async {
        final data = await IsarManager.addOrUpdateMilkRecord(record);
        debugPrint(data.toString());
      });
      callback.call(true);
      refreshData();
    } catch (e, st) {
      debugPrintStack(label: e.toString(), stackTrace: st);
      callback.call(false);
      refreshData();
    }
  }

  void deleteMilkRecord(MilkRecord record, Function callback) async {
    try {
      await SupabaseHelper.deleteMilkRecord(record);
      await IsarManager.isar?.writeTxn(() async {
        final data = await IsarManager.deleteMilkRecord(record);
        debugPrint(data.toString());
      });
      callback.call(true);
      refreshData();
    } catch (e, st) {
      debugPrintStack(label: e.toString(), stackTrace: st);
      callback.call(false);
      refreshData();
    }
  }

  List<MilkRecord> getMilkRecords(String date, Shift shift) {
    return IsarManager.getMilkRecordsData(date, shift);
  }

  void refreshData() {
    final refreshedRecords = getMilkRecords(state.date, state.shift);
    final preferenceRecords = IsarManager.getPreferenceMilkRecords(state.date, state.shift);
    state = state.copyWith(records: refreshedRecords,preferenceRecords: preferenceRecords);
  }

  Future refreshRemoteData() async {
    try {
      final result = await IsarManager.isar?.writeTxn(() async {
        final data = await SupabaseHelper.getRecordsForDate(state.date);
        for (var milkData in data) {
          milkData.timeStamp = DateTime.now().millisecondsSinceEpoch;
          IsarManager.addOrUpdateMilkRecord(milkData);
        }
      });
      refreshData();
      return result;
    } catch (err) {
      return Future.error(err);
    }
  }
}

final pageStateProvider = StateNotifierProvider.family
    .autoDispose<PageStateProvider, PageState, String>(
        (ref, date) => PageStateProvider(date));
