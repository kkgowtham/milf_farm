import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:milk_farm/isar_manager.dart';
import 'package:milk_farm/model/milk_data.dart';
import 'package:milk_farm/model/state/page_state.dart';
import 'package:milk_farm/remote_manager.dart';

class PageStateProvider extends StateNotifier<PageState> {
  PageStateProvider(String date)
      : super(PageState(
            date: date,
            shift: Shift.morning,
            records: IsarManager.getAllMilkRecords(date, Shift.morning),
            isLoading: true));

  onDateChanged(String date) {
    state = state.copyWith(
        date: date,
        shift: Shift.morning,
        isLoading: false,
        records: getMilkRecords(state.date, Shift.morning));
  }

  onShiftChanged(Shift shift) {
    state = state.copyWith(
        shift: shift, records: getMilkRecords(state.date, shift));
  }

  void updateMilkRecord(
      MilkRecord record, double totalLitres, Function callback) async {
    record.totalLitres = totalLitres;
    try {
      await RemoteManager.addOrUpdateMilkRecord(record);
      await IsarManager.isar?.writeTxn(() async {
        final data = await IsarManager.addOrUpdateMilkRecord(record);
        debugPrint(data.toString());
      });
      callback.call(true);
      refreshData();

    } catch (e,st) {
      debugPrintStack(label: e.toString(),stackTrace: st);
      callback.call(false);
      refreshData();
    }
  }

  List<MilkRecord> getMilkRecords(String date, Shift shift) {
    return IsarManager.getAllMilkRecords(date, shift);
  }

  void refreshData() {
    final refreshedRecords = getMilkRecords(state.date, state.shift);
    state = state.copyWith(records: refreshedRecords);

  }

  Future refreshRemoteData() async {
    try {
      final result = await IsarManager.isar?.writeTxn(() async {
        final data = await RemoteManager.getMilkRecords(state.date);
        for (var element in data.docs) {
          IsarManager.addOrUpdateMilkRecord(
              MilkRecord.fromJson(element.data()));
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
