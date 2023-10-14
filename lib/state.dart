import 'package:isar/isar.dart';
import 'package:milk_farm/model/customer.dart';
import 'package:milk_farm/model/milk_data.dart';
import 'package:path_provider/path_provider.dart';

Future<Isar> getCustomerIsar() async {
  final dir = await getApplicationDocumentsDirectory();
  return Isar.open([CustomerSchema,MilkRecordSchema], directory: dir.path,inspector: true);
}


