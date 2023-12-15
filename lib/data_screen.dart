import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:milk_farm/customers.dart';
import 'package:milk_farm/date_utils.dart';
import 'package:milk_farm/extensions.dart';
import 'package:milk_farm/model/customer.dart';
import 'package:milk_farm/model/milk_data.dart';
import 'package:milk_farm/state/filter_state_provider.dart';
import "package:collection/collection.dart";

class FilterDataScreen extends ConsumerWidget {
  const FilterDataScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(filterStateProvider);
    final stateProvider = ref.watch(filterStateProvider.notifier);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Get Data"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 12,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CustomersWidget(
                            selectCustomer: true,
                            selectCallback: (Customer customer) {
                              ref.read(filterStateProvider.notifier).state =
                                  state.copyWith(customer: customer);
                            },
                          )));
                },
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.people,
                            size: 30,
                            color: Colors.black54,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            state.customer?.name ?? "Select Customer",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: (state.customer == null)
                                    ? Colors.grey
                                    : Colors.black),
                          ),
                        ],
                      ),
                      const FractionallySizedBox(
                        widthFactor: .8,
                        child: Divider(),
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      _selectStartDate(
                          context, ref.read(filterStateProvider.notifier));
                    },
                    child: Column(
                      children: [
                        TextButton(
                            onPressed: () {
                              _selectStartDate(context,
                                  ref.read(filterStateProvider.notifier));
                            },
                            child: const Text("Select Start Date")),
                        Text(state.fromDate?.displayFormat ?? "-")
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _selectEndDate(
                          context, ref.read(filterStateProvider.notifier));
                    },
                    child: Column(
                      children: [
                        TextButton(
                            onPressed: () {
                              _selectEndDate(context,
                                  ref.read(filterStateProvider.notifier));
                            },
                            child: const Text("Select End Date")),
                        Text(state.toDate?.displayFormat ?? "-")
                      ],
                    ),
                  )
                ],
              ),
              const FractionallySizedBox(
                widthFactor: .8,
                child: Divider(),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: (state.customer != null &&
                          state.fromDate != null &&
                          state.toDate != null)
                      ? () {
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) {
                                return DataScreen();
                              });
                          ref.read(filterStateProvider.notifier).fetchData();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Background
                    foregroundColor: Colors.white, // Foreground
                  ),
                  child: const Text("Fetch Data")),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ));
  }

  Map<String, List<MilkRecord>> getFilteredList(List<MilkRecord> records) {
    var newMap = groupBy(records, (MilkRecord obj) => obj.date);
    return newMap;
  }

  Future<void> _selectStartDate(
      BuildContext context, FilterStateProvider provider) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: provider.state.fromDate ?? DateTime.now(),
        firstDate: DateTime(2022, 1),
        lastDate: DateTime.now());
    if (picked != null) {
      provider.state = provider.state.copyWith(
        fromDate: picked,
      );
    }
  }

  Future<void> _selectEndDate(
      BuildContext context, FilterStateProvider provider) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: provider.state.toDate ?? DateTime.now(),
        firstDate: DateTime(2022, 1),
        lastDate: DateTime.now());
    if (picked != null) {
      provider.state = provider.state.copyWith(
        toDate: picked,
      );
    }
  }
}

class DataScreen extends ConsumerWidget {
  const DataScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateProvider = ref.watch(filterStateProvider.notifier);
    final state = ref.watch(filterStateProvider);
    return SizedBox(
      width: double.infinity,
      height: context.height * 0.95,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 36,
                  )),
              const SizedBox(
                width: 15,
              )
            ],
          ),
          (state.isLoading)
              ? const Center(
                  child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator()),
                )
              : Expanded(
                  child: Column(
                    children: [
                      Card(
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: context.width,
                            child: Column(
                              children: [
                                Row(children: [
                                  getRowData("Name", state.customer?.name ?? "",
                                      showDivider: true),
                                  getRowData(
                                      "Total Days",
                                      stateProvider
                                          .getAllDates()
                                          .length
                                          .toString(),
                                      showDivider: true),
                                  getRowData("Total Litres", () {
                                    double total = 0;
                                    for (var element in state.records) {
                                      total += element.totalLitres;
                                    }
                                    return total.toString();
                                  }()),
                                ]),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(children: [
                                  getRowData("Morning Litres", () {
                                    double total = 0;
                                    for (var element in state.records) {
                                      if (element.shift == Shift.morning) {
                                        total += element.totalLitres;
                                      }
                                    }
                                    return total.toString();
                                  }(), showDivider: true),
                                  getRowData("Evening Litres", () {
                                    double total = 0;
                                    for (var element in state.records) {
                                      if (element.shift == Shift.evening) {
                                        total += element.totalLitres;
                                      }
                                    }
                                    return total.toString();
                                  }())
                                ]),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              // you can play with this value, by default it is 1
                              child: Center(child: Text("Date")),
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(child: Text("Morning")),
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(child: Text("Evening")),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              final date = stateProvider.getAllDates()[index];
                              final morningLitres = state.records
                                      .firstWhereOrNull((element) =>
                                          element.date == date.isoFormat &&
                                          element.shift == Shift.morning)
                                      ?.totalLitres ??
                                  " - ";
                              final eveningLitres = state.records
                                      .firstWhereOrNull((element) =>
                                          element.date == date.isoFormat &&
                                          element.shift == Shift.evening)
                                      ?.totalLitres ??
                                  " - ";
                              return ListTile(
                                title: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      // you can play with this value, by default it is 1
                                      child: Center(
                                          child: Text(date.displayFormat)),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child:
                                          Center(child: Text("$morningLitres")),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child:
                                          Center(child: Text("$eveningLitres")),
                                    ),
                                  ],
                                ),
                              );
                            },
                            itemCount: stateProvider.getAllDates().length,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
        ],
      ),
    );
  }

  getRowData(String key, String value, {bool showDivider = false}) {
    return Expanded(
      flex: 3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                key,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              Text(value,
                  style: const TextStyle(
                      color: Colors.yellow,
                      fontSize: 15,
                      fontWeight: FontWeight.w400)),
            ],
          ),
          const Spacer(),
          showDivider
              ? const SizedBox(
                  height: 40, child: VerticalDivider(color: Colors.white))
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
