import 'package:flutter/material.dart';
import 'package:milk_farm/days_screen.dart';

class DayWiseWidget extends StatefulWidget {
  const DayWiseWidget({super.key});

  @override
  State<DayWiseWidget> createState() => _DayWiseWidgetState();
}

class _DayWiseWidgetState extends State<DayWiseWidget> {
  final PageController _controller = PageController();

  final List<DateTime> dateList = [];

  @override
  void initState() {
    super.initState();
    dateList.clear();
    for (var i = 0; i < 30; i++) {
      final now = DateTime.now();
      dateList.add(now.subtract(Duration(days: i)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView.builder(
        controller: _controller,
        itemCount: dateList.length,
        reverse: true,
        itemBuilder: (BuildContext context, int index) {
          return DayDetailsWidget(dateList[index]);
        },
      ),
    );
  }
}
