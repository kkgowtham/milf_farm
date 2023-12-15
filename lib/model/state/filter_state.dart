import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:milk_farm/date_utils.dart';
import 'package:milk_farm/model/customer.dart';
import 'package:milk_farm/model/milk_data.dart';

part 'filter_state.freezed.dart';

@freezed
class FilterState with _$FilterState {
  const factory FilterState({
    required bool isLoading,
    DateTime? fromDate,
    DateTime? toDate,
    Customer? customer,
    required List<MilkRecord> records,
  }) = _FilterState;

  const FilterState._();
}
