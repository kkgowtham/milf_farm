import 'package:flutter/material.dart';
import 'package:milk_farm/date_utils.dart';
import 'package:milk_farm/extensions.dart';

class DayDetailsWidget extends StatefulWidget {
  final DateTime dateTime;

  const DayDetailsWidget(this.dateTime, {super.key});

  @override
  State<DayDetailsWidget> createState() => _DayDetailsWidgetState();
}

class _DayDetailsWidgetState extends State<DayDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: context.height * .8,
          width: context.width * .8,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide(
                color: Colors.grey.shade200,
                width: 2.0,
              ),
            ),
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
                const SizedBox(
                  height: 10,
                ),
                const Text("Morning "),
                const SizedBox(
                  height: 10,
                ),
                getDataColumn("Total Litres",""),
                const Text("Evening"),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget getDataColumn(String header,String value){
    return DataTable(
        columns: const [
          DataColumn(
            label: Text('ID'),
          ),
          DataColumn(
            label: Text('Name'),
          ),
          DataColumn(
            label: Text('Code'),
          ),
          DataColumn(
            label: Text('Quantity'),
          ),
          DataColumn(
            label: Text('Amount'),
          ),
        ],
        rows: const [

          DataRow(cells: [
            DataCell(Text('1')),
            DataCell(Text('Arshik')),
            DataCell(Text('5644645')),
            DataCell(Text('3')),
            DataCell(Text('265\$')),
          ])
        ]);
  }
}


