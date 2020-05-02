import 'dart:async';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BarChartSample1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BarChartSample1State();
}

class BarChartSample1State extends State<BarChartSample1> {
  final Color barBackgroundColor = Colors.cyan.shade600;
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex;

  bool isPlaying = false;

  Map monthNames = {
    1: "January",
    2: "February",
    3: "March",
    4: "April",
    5: "May",
    6: "June",
    7: "July",
    8: "August",
    9: "September",
    10: "October",
    11: "November",
    12: "December"
  };

  String notebookName;

  @override
  Widget build(BuildContext context) {
    final notebookArgs args = ModalRoute.of(context).settings.arguments;
    notebookName = args.name;

    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: Colors.cyan,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    'Last 7 Days',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    '${monthNames[today.month]}',
                    style: TextStyle(
                        color: Colors.cyan.shade100,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 38,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: BarChart(
                        mainBarData(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.white,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          color: isTouched ? Colors.yellow : barColor,
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 20,
            color: barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  Map noteBookMonthData = {};
  var today = new DateTime.now();

  dateData() async {
    noteBookMonthData = await user.getNoteBookContentMonth(
        notebookName, today.year, today.month);
  }

  makeWeekLabels() {
    //debug prints
    print("The day: ${today.day}");
    print("The Notebook Name: $notebookName");
    print("The Map: $noteBookMonthData");
    print("The Data: ${noteBookMonthData[today.day]}");

    var weekLabels;
    int day = today.day;

    switch (day) {
      case 1:
        weekLabels = [1, "", "", "", "", "", ""];
        break;
      case 2:
        weekLabels = [1, 2, "", "", "", "", ""];
        break;
      case 3:
        weekLabels = [1, 2, 3, "", "", "", ""];
        break;
      case 4:
        weekLabels = [1, 2, 3, 4, "", "", ""];
        break;
      case 5:
        weekLabels = [1, 2, 3, 4, 5, "", ""];
        break;
      case 6:
        weekLabels = [1, 2, 3, 4, 5, 6, ""];
        break;
      case 7:
        weekLabels = [1, 2, 3, 4, 5, 6, 7];
        break;

      default:
        weekLabels = [
          day - 6,
          day - 5,
          day - 4,
          day - 3,
          day - 2,
          day - 1,
          day
        ];
    }
    return weekLabels;
  }

  makeWeekData() {
    var weekData;
    int day = today.day;

    switch (day) {
      case 1:
        weekData = [noteBookMonthData["1"], 0, 0, 0, 0, 0, 0];
        break;
      case 2:
        weekData = [noteBookMonthData["1"], noteBookMonthData["2"], 0, 0, 0, 0, 0];
        break;
      case 3:
        weekData = [
          noteBookMonthData["1"],
          noteBookMonthData["2"],
          noteBookMonthData["3"],
          0,
          0,
          0,
          0
        ];
        break;
      case 4:
        weekData = [
          noteBookMonthData["1"],
          noteBookMonthData["2"],
          noteBookMonthData["3"],
          noteBookMonthData["4"],
          0,
          0,
          0
        ];
        break;
      case 5:
        weekData = [
          noteBookMonthData["1"],
          noteBookMonthData["2"],
          noteBookMonthData["3"],
          noteBookMonthData["4"],
          noteBookMonthData["5"],
          0,
          0
        ];
        break;
      case 6:
        weekData = [
          noteBookMonthData["1"],
          noteBookMonthData["2"],
          noteBookMonthData["3"],
          noteBookMonthData["4"],
          noteBookMonthData["5"],
          noteBookMonthData["6"],
          0
        ];
        break;
      case 7:
        weekData = [
          noteBookMonthData["1"],
          noteBookMonthData["2"],
          noteBookMonthData["3"],
          noteBookMonthData["4"],
          noteBookMonthData["5"],
          noteBookMonthData["6"],
          noteBookMonthData["7"]
        ];
        break;

      default:
        weekData = [
          noteBookMonthData[day - 6],
          noteBookMonthData[day - 5],
          noteBookMonthData[day - 4],
          noteBookMonthData[day - 3],
          noteBookMonthData[day - 2],
          noteBookMonthData[day - 1],
          noteBookMonthData[day]
        ];
    }

    for (int k = 0; k < 7; k++) {
      if (weekData[k] == null) weekData[k] = 0;
    }

    return weekData;
  }

  List<BarChartGroupData> showingGroups(weekData) => List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, weekData[0].toDouble(),
                isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, weekData[1].toDouble(),
                isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, weekData[2].toDouble(),
                isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, weekData[3].toDouble(),
                isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(4, weekData[4].toDouble(),
                isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(5, weekData[5].toDouble(),
                isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(6, weekData[6].toDouble(),
                isTouched: i == touchedIndex);
          default:
            return null;
        }
      });

  checkZero(x) {
    if (x == 0) {
      return "";
    } else {
      print(x.toString());
      return x.toString();
    }
  }

  BarChartData mainBarData() {
    var weekLabels = makeWeekLabels();
    var weekData = makeWeekData();
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.cyan.shade800,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = "${monthNames[today.month]} ${weekLabels[0]}";
                  break;
                case 1:
                  weekDay = "${monthNames[today.month]} ${weekLabels[1]}";
                  break;
                case 2:
                  weekDay = "${monthNames[today.month]} ${weekLabels[2]}";
                  break;
                case 3:
                  weekDay = "${monthNames[today.month]} ${weekLabels[3]}";
                  break;
                case 4:
                  weekDay = "${monthNames[today.month]} ${weekLabels[4]}";
                  break;
                case 5:
                  weekDay = "${monthNames[today.month]} ${weekLabels[5]}";
                  break;
                case 6:
                  weekDay = "${monthNames[today.month]} ${weekLabels[6]}";
                  break;
              }
              return BarTooltipItem(weekDay + '\n' + (rod.y - 1).toString(),
                  TextStyle(color: Colors.yellow));
            }),
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! FlPanEnd &&
                barTouchResponse.touchInput is! FlLongPressEnd) {
              touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
            } else {
              touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return weekLabels[0].toString();
              case 1:
                return weekLabels[1].toString();
              case 2:
                return weekLabels[2].toString();
              case 3:
                return weekLabels[3].toString();
              case 4:
                return weekLabels[4].toString();
              case 5:
                return weekLabels[5].toString();
              case 6:
                return weekLabels[6].toString();
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(weekData),
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
        animDuration + const Duration(milliseconds: 50));
    if (isPlaying) {
      refreshState();
    }
  }
}
