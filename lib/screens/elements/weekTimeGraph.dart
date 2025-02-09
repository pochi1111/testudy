import 'package:flutter/material.dart';
import 'package:testudy/configs/appTheme.dart';
import 'package:fl_chart/fl_chart.dart';

class WeekTimeGraph extends StatelessWidget {
  final List<int> studyTimesInt;

  const WeekTimeGraph({
    Key? key,
    required this.studyTimesInt,
  }) : super(key: key);

  static const double barWidth = 20.0;
  final TextStyle _labelStyle =
      const TextStyle(fontSize: 16, fontWeight: FontWeight.w800);

  @override
  Widget build(BuildContext context) {
    final maxY = studyTimesInt
        .reduce((value, element) => value > element ? value : element)
        .toDouble();
    late int interval;
    if (maxY < 60) {
      interval = 10;
    } else if (maxY < 120) {
      interval = 20;
    } else {
      interval = 30;
    }
    return BarChart(
      BarChartData(
        gridData: FlGridData(
          show: true,
          checkToShowHorizontalLine: (value) => value.toInt() % interval == 0,
          getDrawingHorizontalLine: (value) => FlLine(
            color: appTheme.primaryColor.withValues(alpha: 0.1),
            strokeWidth: 1,
          ),
          drawVerticalLine: false,
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(
              color: appTheme.primaryColor.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
        ),
        maxY: maxY,
        alignment: BarChartAlignment.spaceEvenly,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipMargin: 0,
            getTooltipColor: (_) => Colors.transparent,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final minutes = studyTimesInt[group.x.toInt()];
              final hours = minutes ~/ 60;
              final remainingMinutes = minutes % 60;
              late String txt;
              if (hours > 0) {
                if (remainingMinutes > 0) {
                  txt = '$hours時間\n$remainingMinutes分';
                } else {
                  txt = '$hours時間';
                }
              } else {
                txt = '$remainingMinutes分';
              }
              return BarTooltipItem(
                txt,
                const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              maxIncluded: false,
              minIncluded: false,
              reservedSize: 50,
              interval: interval.toDouble(),
              getTitlesWidget: (value, meta) {
                final minutes = value.toInt();
                final hours = minutes ~/ 60;
                final remainingMinutes = minutes % 60;
                String txt;
                if (hours > 0) {
                  if (remainingMinutes > 0) {
                    txt = '$hours時間\n$remainingMinutes分';
                  } else {
                    txt = '$hours時間';
                  }
                } else {
                  txt = '$minutes分';
                }
                return SideTitleWidget(
                  meta: meta,
                  child: Text(
                    txt,
                    style: TextStyle(
                      color: appTheme.primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getTitles,
              reservedSize: 25,
            ),
          ),
        ),
        barGroups: graphdata(),
      ),
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: appTheme.primaryColor,
      fontWeight: FontWeight.w600,
      fontSize: 14,
    );
    Widget text;
    DateTime label = DateTime.now();
    label = label.subtract(Duration(days: 6 - value.toInt()));
    text = Text('${label.month}/${label.day}', style: style);
    return SideTitleWidget(
      meta: meta,
      space: 5,
      child: text,
    );
  }

  List<BarChartGroupData> graphdata() => List.generate(7, (i) {
        return BarChartGroupData(x: i, barRods: [
          BarChartRodData(
              toY: studyTimesInt[i].toDouble(),
              width: barWidth,
              borderRadius: const BorderRadius.all(Radius.zero))
        ]);
      });
}
