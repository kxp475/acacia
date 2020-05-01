import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'main.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'notebook_view.dart';

class BarChartSample1 extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => BarChartSample1State();
}

class BarChartSample1State extends State<BarChartSample1> {
  final Color barBackgroundColor = Colors.cyan.shade600;
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex;

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
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
                    'This Week',
                    style: TextStyle(
                        color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 4,
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

  dateData() async {
	String notebookName;
  	Map noteBookMonthData = {};
      	var today = new DateTime.now();
	var week;

	noteBookMonthData = await user.getNoteBookContentMonth(notebookName,today.year,today.month);

	switch(today.weekday) {
		case 7:
			week = [noteBookMonthData[today.day],0,0,0,0,0,0];
			break;
		case 1:
			week = [noteBookMonthData[today.day-1],noteBookMonthData[today.day],0,0,0,0,0];
			break;
		case 2:
			week = [noteBookMonthData[today.day-2],noteBookMonthData[today.day-1],noteBookMonthData[today.day],0,0,0,0];
			break;
		case 3:
			week = [noteBookMonthData[today.day-3],noteBookMonthData[today.day-2],noteBookMonthData[today.day-1],noteBookMonthData[today.day],0,0,0];
			break;
		case 4:
			week = [noteBookMonthData[today.day-4],noteBookMonthData[today.day-3],noteBookMonthData[today.day-2],noteBookMonthData[today.day-1],
				noteBookMonthData[today.day],0,0];
			break;
		case 5:
			week = [noteBookMonthData[today.day-5],noteBookMonthData[today.day-4],noteBookMonthData[today.day-3],noteBookMonthData[today.day-2],
				noteBookMonthData[today.day-1],noteBookMonthData[today.day],0];
			break;
		case 6:
			week = [noteBookMonthData[today.day-6],noteBookMonthData[today.day-5],noteBookMonthData[today.day-4],noteBookMonthData[today.day-3],
				noteBookMonthData[today.day-2],noteBookMonthData[today.day-1],noteBookMonthData[today.day]];
			break;

		default:
			return null;

	}
	print(week);

      setState((){});
	return week;
  }

  weekGetter() async {
	  final List week = await dateData();
	  return week;
  }


  List<BarChartGroupData> showingGroups(week) => List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, week[0].toDouble(), isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, 6.5, isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, 5, isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, 7.5, isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(4, 9, isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(5, 11.5, isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(6, 6.5, isTouched: i == touchedIndex);
          default:
            return null;
        }
      });
  

  BarChartData mainBarData() {
	  var week = weekGetter();
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.cyan.shade800,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = 'Sunday';
                  break;
                case 1:
                  weekDay = 'Monday';
                  break;
                case 2:
                  weekDay = 'Tuesday';
                  break;
                case 3:
                  weekDay = 'Wednesday';
                  break;
                case 4:
                  weekDay = 'Thursday';
                  break;
                case 5:
                  weekDay = 'Friday';
                  break;
                case 6:
                  weekDay = 'Saturday';
                  break;
              }
              return BarTooltipItem(
                  weekDay + '\n' + (rod.y - 1).toString(), TextStyle(color: Colors.yellow));
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
          textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'S';
              case 1:
                return 'M';
              case 2:
                return 'T';
              case 3:
                return 'W';
              case 4:
                return 'T';
              case 5:
                return 'F';
              case 6:
                return 'S';
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
      barGroups: showingGroups(week),
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(animDuration + const Duration(milliseconds: 50));
    if (isPlaying) {
      refreshState();
    }
  }
}

