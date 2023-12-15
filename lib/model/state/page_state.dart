import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:milk_farm/isar_manager.dart';
import 'package:milk_farm/model/milk_data.dart';

part 'page_state.freezed.dart';

@freezed
class PageState with _$PageState {
  const factory PageState(
      {required String date,
      required Shift shift,
      required List<MilkRecord> records,
      required bool isLoading}) = _PageState;

  const PageState._();

  double getTotalLitres() {
    return IsarManager.getTotalLitres(date);
  }

  double getMorningLitres() {
    return IsarManager.getTotalLitresForShift(date, Shift.morning);
  }

  double getEveningLitres() {
    return IsarManager.getTotalLitresForShift(date, Shift.evening);
  }
}
