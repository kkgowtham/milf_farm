import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:milk_farm/model/milk_data.dart';

part 'page_state.freezed.dart';

@freezed
class PageState with _$PageState {
  const factory PageState(
      {required String date,
      required Shift shift,
      required List<MilkRecord> records,required bool isLoading}) = _PageState;
}
