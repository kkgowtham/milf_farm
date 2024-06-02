import 'package:flutter/cupertino.dart' show CupertinoSegmentedControl;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:milk_farm/date_utils.dart';
import 'package:milk_farm/extensions.dart';
import 'package:milk_farm/isar_manager.dart';
import 'package:milk_farm/model/customer.dart';
import 'package:milk_farm/model/milk_data.dart';
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
          physics: const BouncingScrollPhysics(),
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
                      getData(
                          "Total Litres", state.getTotalLitres().toString()),
                      getData("Morning", state.getMorningLitres().toString()),
                      getData("Evening", state.getEveningLitres().toString()),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: CupertinoSegmentedControl(
                    children: {
                      Shift.morning: getSegmentControlWidget("Morning"),
                      Shift.evening: getSegmentControlWidget("Evening")
                    },
                    groupValue: state.shift,
                    onValueChanged: (data) {
                      setState(() {
                        ref
                            .watch(pageStateProvider(widget.dateTime.isoFormat)
                                .notifier)
                            .onShiftChanged(data);
                      });
                    }),
              ),
              const SizedBox(
                height: 10,
              ),
              getDataColumn(state.records,context),
              const SizedBox(
                height: 10,
              ),
              getDataColumn(state.preferenceRecords,context, isNewRecord: true),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      )
    ]);
  }

  Widget getDataColumn(List<MilkRecord> list,BuildContext context, {bool isNewRecord = false}) {
    return IgnorePointer(
      ignoring: list.isEmpty,
      child: ExpansionTile(
        title: Text(
          isNewRecord ? "Customers" : "Milk Records",
          style: const TextStyle(
            color: Colors.deepPurpleAccent,
            fontWeight: FontWeight.w600,
          ),
        ),
        initiallyExpanded: true,
        shape: const Border(),
        children: [
          (list.isEmpty)
              ? const Text("No Data Found")
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      if (isNewRecord) {
                        return getHeaderRow("Name", "Preference(Ltrs)");
                      } else {
                        return getHeaderRow("Name", "Litres");
                      }
                    }
                    return getRowData(list[index - 1], isNewRecord, index - 1,context);
                  },
                  itemCount: list.length + 1,
                )
        ],
      ),
    );
  }

  Widget getHeaderRow(String value1, String value2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
            child: FractionallySizedBox(
                widthFactor: 0.5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      value1,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ))),
        Flexible(
          child: FractionallySizedBox(
            widthFactor: 1,
            child: Center(
              child: Text(
                value2,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget getRowItem(MilkRecord record, bool isNewRecord, int index,BuildContext context) {
    final Customer? customer = IsarManager.getCustomerById(record.uuid);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
                child: FractionallySizedBox(
                    widthFactor: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          "${customer?.name}",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ))),
            Flexible(
              child: FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    record.totalLitres.toString(),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (!isNewRecord) {
                  _showYesNoDialog(context, () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        });
                    ref
                        .watch(pageStateProvider(widget.dateTime.isoFormat)
                            .notifier)
                        .deleteMilkRecord(record, (data) {
                      Navigator.of(context).pop();
                    });
                  });
                  return;
                }
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    });

                ref
                    .watch(
                        pageStateProvider(widget.dateTime.isoFormat).notifier)
                    .addMilkRecord(record, (data) {
                  Navigator.of(context).pop();
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black54, // Set your desired stroke color
                      width: 2.0, // Set your desired stroke width
                    ),
                  ),
                  child: Icon(
                    (isNewRecord) ? Icons.add : Icons.remove,
                    size: 24.0,
                    color: Colors.black54, // Set your desired icon color
                  ),
                ),
              ),
            ),
          ],
        ),
        const Divider()
      ],
    );
  }

  Widget getRowData(MilkRecord record, bool isNewRecord, int i,BuildContext context) {
    int itemSelection = !quantities.contains(record.totalLitres)
        ? 0
        : quantities.indexOf(record.totalLitres);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: getRowItem(record, isNewRecord, i,context),
      onTap: () {
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

Future<void> _showYesNoDialog(
    BuildContext context, Function onYesPressed) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Do you want to proceed?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Dismiss the dialog
              // Perform actions for "No" if needed
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Dismiss the dialog
              // Call the callback for "Yes"
              onYesPressed();
            },
            child: const Text('Yes'),
          ),
        ],
      );
    },
  );
}
