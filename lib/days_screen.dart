import 'package:flutter/cupertino.dart' show CupertinoSegmentedControl;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:milk_farm/date_utils.dart';
import 'package:milk_farm/extensions.dart';
import 'package:milk_farm/isar_manager.dart';
import 'package:milk_farm/model/customer.dart';
import 'package:milk_farm/model/milk_data.dart';
import 'package:milk_farm/model/state/page_state.dart';
import 'package:milk_farm/state/page_state_provider.dart';

class DayDetailsWidget extends ConsumerStatefulWidget {
  final DateTime dateTime;

  const DayDetailsWidget(this.dateTime, {super.key});

  @override
  ConsumerState<DayDetailsWidget> createState() => _DayDetailsWidgetState();
}

class _DayDetailsWidgetState extends ConsumerState<DayDetailsWidget> {
  List<double> quantities = [0, .25, .50, 1, 1.5, 2, 2.5, 3];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pageStateProvider(widget.dateTime.isoFormat));
    return Stack(children: [
      Column(
        children: [
          RefreshIndicator(
            displacement: 100,
            backgroundColor: Colors.purple,
            color: Colors.white,
            strokeWidth: 3,
            onRefresh: () {
              return ref
                  .watch(pageStateProvider(widget.dateTime.isoFormat).notifier)
                  .refreshRemoteData();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.dateTime.displayFormat,
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("Milk Data"),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          getData("Total Litres",
                              state.getTotalLitres().toString()),
                          getData(
                              "Morning", state.getMorningLitres().toString()),
                          getData(
                              "Evening", state.getEveningLitres().toString()),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CupertinoSegmentedControl(
                      children: {
                        Shift.morning: getSegmentControlWidget("Morning"),
                        Shift.evening: getSegmentControlWidget("Evening")
                      },
                      groupValue: state.shift,
                      onValueChanged: (data) {
                        setState(() {
                          ref
                              .watch(
                                  pageStateProvider(widget.dateTime.isoFormat)
                                      .notifier)
                              .onShiftChanged(data);
                        });
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  getDataColumn(state),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      Positioned(
        right: 20,
        bottom: 20,
        child: FloatingActionButton(
          onPressed: () {
/*
            IsarManager.getAllMilkRecords(
                    widget.dateTime.isoFormat, Shift.values[groupValue])
                .forEach((element) {
            });
*/

            /*
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CustomersWidget(
                      selectCustomer: true,
                      selectCallback: (Customer customer) {
                        Future.delayed(const Duration(milliseconds: 100),
                            () async {
                          await showDialog(
                            context: context,
                            builder: (_) => Text(customer.name),
                          );
                        });
                      },
                    )));*/
          },
        ),
      )
    ]);
  }

  Widget getDataColumn(PageState state) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
          showCheckboxColumn: false,
          columns: const [
            DataColumn(
              label: Text('Name'),
            ),
            DataColumn(
              label: Text('Litres'),
            ),
          ],
          rows: state.records.map((e) => getRowData(e)).toList()),
    );
  }

  DataRow getRowData(MilkRecord record) {
    final Customer? customer = IsarManager.getCustomerById(record.uuid);
    int itemSelection = !quantities.contains(record.totalLitres)
        ? 0
        : quantities.indexOf(record.totalLitres);
    return DataRow(
      cells: [
        DataCell(Text(customer?.name ?? "")),
        DataCell(Text(record.totalLitres.toString())),
      ],
      onSelectChanged: (value) {
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext buildContext) {
            return Padding(
              padding: MediaQuery.of(buildContext).viewInsets,
              child: StatefulBuilder(
                  builder: (BuildContext buildContext, StateSetter setState) {
                return SizedBox(
                    height: 200,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18.0),
                                    child: TextButton(
                                        onPressed: () async {
                                          ref
                                              .watch(pageStateProvider(
                                                      widget.dateTime.isoFormat)
                                                  .notifier)
                                              .updateMilkRecord(record,
                                                  quantities[itemSelection],
                                                  (status) {
                                            if (!mounted) return;
                                            context.pop();
                                            if (status) {
                                              context
                                                  .showSnackBar("Data Updated");
                                            } else {
                                              context.showSnackBar(
                                                  "Error Occurred");
                                            }
                                          });
                                        },
                                        child: const Text(
                                          "Save",
                                          style: TextStyle(fontSize: 16),
                                        )),
                                  ),
                                ],
                              ),
                              Wrap(
                                spacing: 6,
                                children:
                                    List.generate(quantities.length, (index) {
                                  String myString =
                                      "${quantities[index].toString().replaceAll(RegExp(r'\.0+$'), '')} L";
                                  return ChoiceChip(
                                    label: Text(myString),
                                    showCheckmark: false,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    selected: index == itemSelection,
                                    color: MaterialStateColor.resolveWith(
                                        (states) {
                                      // If the button is pressed, return green, otherwise blue
                                      if (states
                                          .contains(MaterialState.selected)) {
                                        return Colors.purpleAccent.shade700;
                                      }
                                      return Colors.black54;
                                    }),
                                    checkmarkColor: Colors.white,
                                    onSelected: (bool selected) {
                                      setState(() {
                                        itemSelection = index;
                                      });
                                    },
                                    labelStyle:
                                        const TextStyle(color: Colors.white),
                                  );
                                }),
                              )
                            ],
                          )
                        ],
                      ),
                    ));
              }),
            );
          },
        );
      },
    );
  }

  Widget getSegmentControlWidget(String text) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget getData(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(key),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
