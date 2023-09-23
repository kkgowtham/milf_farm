import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'date_utils.dart';

class CalendarView extends ConsumerStatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CalendarView(this.scaffoldKey, {Key? key}) : super(key: key);

  @override
  ConsumerState<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends ConsumerState<CalendarView> {
  PersistentBottomSheetController? persistentBottomSheetController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    final currentMonth = ref.watch(calendarState);
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: (canGoToPreviousMonth(currentMonth))
                      ? () {
                          ref.read(calendarState.notifier).state =
                              previousMonth(currentMonth);
                        }
                      : null,
                  icon: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: canGoToPreviousMonth(currentMonth)
                        ? Colors.blueGrey
                        : Colors.blueGrey.shade100,
                    size: 24,
                  )),
              const Spacer(),
              Text(
                DateFormat('MMMM').format(currentMonth),
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
              const SizedBox(
                width: 6,
              ),
              Text(currentMonth.year.toString(),
                  style: const TextStyle(color: Colors.black, fontSize: 18)),
              const Spacer(),
              IconButton(
                onPressed: (canGoToNextMonth(currentMonth))
                    ? () {
                        ref.read(calendarState.notifier).state =
                            nextMonth(currentMonth);
                      }
                    : null,
                icon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: canGoToNextMonth(currentMonth)
                      ? Colors.blueGrey
                      : Colors.blueGrey.shade100,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            children: weekdays
                .map((day) => Column(
                      children: [
                        Text(
                          day,
                          style: const TextStyle(color: Colors.blueGrey),
                        ),
                        const Spacer()
                      ],
                    ))
                .toList(),
          ),
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            children: daysInMonth(ref.read(calendarState))
                .map((date) => Column(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: date.isToday
                              ? const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.blue)
                              : null,
                        ),
                        GestureDetector(
                          onTap: () {
                            showBottomSheet(context, date);
                          },
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 10, bottom: 2),
                            child: Column(
                              children: [
                                Text(
                                  date.day.toString(),
                                  style: TextStyle(
                                    color: getTextColor(date, currentMonth),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Color getTextColor(DateTime date, DateTime currentMonth) {
    if (isSameMonth(date, currentMonth) && !isSaturdayOrSunday(date)) {
      return Colors.black;
    }
    if (!isSameMonth(date, currentMonth)) {
      return Colors.blueGrey.shade200.withOpacity(0.7);
    }
    return Colors.black;
  }

  void showBottomSheet(BuildContext context, DateTime date) {
    String prefix = "";
    if (date.isToday) {
      prefix = " - Today";
    } else {
      if (date.isYesterday) {
        prefix = " - Yesterday";
      } else if (date.isTomorrow) {
        prefix = " - Tomorrow";
      }
    }
    persistentBottomSheetController =
        widget.scaffoldKey.currentState?.showBottomSheet(
      (builder) {
        return Container(
          padding: const EdgeInsets.all(20),
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${DateFormat(' MMMM dd, yyyy').format(date)}$prefix",
                style: const TextStyle(fontSize: 22,color: Colors.red),
              ),
              const SizedBox(height: 20,),
              GestureDetector(
                child: const Text(
                  "View Data for Selected Date",
                  style: TextStyle(fontSize: 18),
                ),
                onTap: (){
                  
                },
              ),
              const SizedBox(height: 20,),
              GestureDetector(
                child: const Text(
                  "Update Data for Selected Date",
                  style: TextStyle(fontSize: 18),
                ),
                onTap: (){
                  
                },
              ),
            ],
          ),
        );
      },
      shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          side: BorderSide(
              strokeAlign: BorderSide.strokeAlignCenter,
              color: Colors.grey.withOpacity(0.15),
              width: 4)),
      elevation: 30,
      clipBehavior: Clip.antiAliasWithSaveLayer,
    );
  }
}

final calendarState =
    StateProvider.autoDispose<DateTime>((ref) => DateTime.now());
