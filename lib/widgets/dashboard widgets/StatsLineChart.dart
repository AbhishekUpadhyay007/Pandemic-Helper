import 'package:covid/http/GetData.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class StatsLineChart<T> extends StatefulWidget {
  StatsLineChart(
      {this.gradientColors,
      this.color,
      this.stateCode,
      this.stateName,
      this.callback});

  final List<Color> gradientColors;
  final color;
  final stateName;
  final stateCode;
  final callback;

  @override
  _StatsLineChartState<T> createState() => _StatsLineChartState<T>();
}

class _StatsLineChartState<T> extends State<StatsLineChart<T>> {
  final List<FlSpot> dataList = [];
  var durationDays = 0;
  final List dropDownList = ['All time', 'last 7 days', 'last month'];
  var valueChoose;
  var choice;
  var _maxVal;
  var _interval;

  var isCountryCard;

  List<FlSpot> _getGraphSpot(List<T> list) {
    dataList.clear();
    var max = 0;
    List ll;
    if (T == StateStats) {
      ll = list.cast<StateStats>();
    } else if (T == RecoveredStats) {
      ll = list.cast<RecoveredStats>();
    } else {
      ll = list.cast<CountryStats>();
    }

    for (int i = durationDays; i < ll.length; i++) {
      if (double.parse(ll.elementAt(i).cases) < 0) {
        dataList.add(FlSpot(i.toDouble(), 50));
        continue;
      }

      if (max < int.parse(ll.elementAt(i).cases)) {
        max = int.parse(ll.elementAt(i).cases);
      }

      dataList.add(FlSpot(i.toDouble(), double.parse(ll.elementAt(i).cases)));
    }
    _maxVal = max;
    _interval = _maxVal / 5;
    return dataList;
  }

  List<TouchedSpotIndicatorData> getTouchedSpotIndicator(
      LineChartBarData bardata, List<int> spotIndexes) {
    return spotIndexes.map(
      (spotIndex) {
        final spot = bardata.spots[spotIndex];
        if (spot.x == 0) {
          return null;
        }

        return TouchedSpotIndicatorData(
          FlLine(color: Colors.white, strokeWidth: 1),
          FlDotData(
            getDotPainter: (spot, percent, bardata, i) {
              return FlDotCirclePainter(
                  radius: 4,
                  color: widget.color,
                  strokeWidth: 1.5,
                  strokeColor: Colors.white);
            },
          ),
        );
      },
    ).toList();
  }

  Widget buildCard(isTrue, list) {
    var format = NumberFormat('#,##,000');
    if (isTrue) {
      return Container(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Confirmed:',
                    style: TextStyle(
                        color: Colors.red[400], fontWeight: FontWeight.w800),
                  ),
                  Text(
                    format.format(int.parse(list.cast().last.totalConfirmed)),
                    style: TextStyle(
                        color: Colors.red[400], fontWeight: FontWeight.w800),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recovered:',
                    style: TextStyle(
                        color: Colors.greenAccent[400],
                        fontWeight: FontWeight.w800),
                  ),
                  Text(
                    format.format(int.parse(list.cast().last.totalRecover)),
                    style: TextStyle(
                        color: Colors.greenAccent[400],
                        fontWeight: FontWeight.w800),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Deaths:',
                    style: TextStyle(
                        color: Colors.yellow[800], fontWeight: FontWeight.w800),
                  ),
                  Text(
                    format.format(int.parse(list.cast().last.totalDeaths)),
                    style: TextStyle(
                        color: Colors.yellow[800], fontWeight: FontWeight.w800),
                  )
                ],
              ),
              Text(
                '\nLast Updated: ${list.cast().last.date}',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    isCountryCard = (T == CountryStats) ? true : false;
    List<T> list = [];
    if (T == StateStats) {
      list = Provider.of<GetHttpData>(context).confirmedList.cast();
      choice = 'Confirmes';
    } else if (T == RecoveredStats) {
      list = Provider.of<GetHttpData>(context).recoverList.cast();
      choice = 'Recoveries';
    } else {
      list = Provider.of<GetHttpData>(context).countryStats.cast();
      choice = 'Confirmes';
    }
    var format = NumberFormat('#,##,000');
    var card = Container();
    if (isCountryCard == true) {
      try {
        card = buildCard(isCountryCard, list);
      } catch (error) {
        print(error);
      }
    }

    var _graphSpotList = _getGraphSpot(list);
    return Column(
      children: [
        graphHeader(context, list),
        Container(
          padding: EdgeInsets.only(top: 5, right: 10, left: 8),
          width: double.infinity,
          height: 250,
          child: list.isEmpty
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : LineChart(
                  LineChartData(
                    minY: 0,
                    borderData: FlBorderData(
                      show: false,
                    ),
                    lineTouchData: LineTouchData(
                        enabled: true,
                        getTouchedSpotIndicator: (bardata, spotIndexes) =>
                            getTouchedSpotIndicator(bardata, spotIndexes),
                        touchTooltipData: LineTouchTooltipData(
                            fitInsideHorizontally: true,
                            fitInsideVertically: true,
                            getTooltipItems:
                                (List<LineBarSpot> touchedBarSpots) {
                              return touchedBarSpots.map((barSpot) {
                                final flSpot = barSpot;

                                if (flSpot.x == 0 || flSpot.x == 10) {
                                  return null;
                                }

                                return LineTooltipItem(
                                  T == StateStats
                                      ? 'New Cases: ${format.format(flSpot.y.toInt())}\n'
                                      : T == CountryStats
                                          ? 'Confirmed Cases: ${format.format(flSpot.y.toInt())}\n'
                                          : 'Recovered Cases: ${format.format(flSpot.y.toInt())}\n',
                                  TextStyle(
                                    color: widget.color,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          '${list.cast().elementAt(flSpot.x.toInt()).date} ',
                                      style: TextStyle(
                                        color: widget.color,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    )
                                  ],
                                );
                              }).toList();
                            },
                            tooltipBgColor: Colors.white)),
                    titlesData: FlTitlesData(
                      show: true,
                      leftTitles: SideTitles(
                          showTitles: true,
                          margin: 5,
                          interval: _interval,
                          getTextStyles: (v) {
                            return Theme.of(context).textTheme.headline2;
                          },
                          getTitles: (value) {
                            if (value == 0) {
                              return '0';
                            }
                            String str = value.toInt().toString();

                            if (str.length == 4) {
                              return '${str.substring(0, 1)}.${str.substring(1, 2)}k';
                            }

                            if (str.length == 5) {
                              return '${str.substring(0, 2)}.${str.substring(2, 3)}k';
                            }

                            if (str.length == 6) {
                              return '${str.substring(0, 3)}k';
                            }

                            if (str.length == 7) {
                              return '${str.substring(0, 1)}.${str.substring(1, 2)}m';
                            }

                            return str;
                          }),
                      bottomTitles: SideTitles(
                        showTitles: true,
                        margin: 10,
                        getTextStyles: (v) {
                          return Theme.of(context).textTheme.headline2;
                        },
                        getTitles: (value) {
                          var v = value.toInt();
                          if (v == 0) return '';

                          int r;

                          if (durationDays == 0) {
                            r = v % 100;
                          } else if (durationDays == (list.length - 30)) {
                            r = v % 5;
                          } else {
                            r = v % 1;
                          }

                          switch (r) {
                            case 0:
                              String date = list.cast().elementAt(v).date;
                              var dd;
                              if (date.contains('-')) {
                                dd = date.split("-");
                              } else {
                                dd = date.split(' ');
                              }
                              return '${dd.elementAt(0)} ${dd.elementAt(1).toString().substring(0, 3)}';
                            default:
                              return '';
                          }
                        },
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.black,
                          strokeWidth: .34,
                        );
                      },
                      drawVerticalLine: false,
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: _graphSpotList,
                        isCurved: true,
                        dotData: FlDotData(
                          show: durationDays == 0 ? false : true,
                        ),
                        colors: [widget.color],
                        barWidth: 3,
                        belowBarData: BarAreaData(
                          show: true,
                          colors: widget.gradientColors
                              .map(
                                (color) => color.withOpacity(0.5),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
        card
      ],
    );
  }

  ListTile graphHeader(BuildContext context, List<T> list) {
    return ListTile(
      title: Text(
        'Daily $choice',
        style: Theme.of(context).textTheme.headline5,
      ),
      subtitle: Text(
        'in ${widget.stateName} (${widget.stateCode.toString().toUpperCase()})',
        style: Theme.of(context).textTheme.bodyText2,
      ),
      trailing: DropdownButton(
        elevation: 0,
        icon: Icon(Icons.keyboard_arrow_down),
        hint: Text(dropDownList.elementAt(0)),
        style: Theme.of(context).textTheme.bodyText1,
        value: valueChoose,
        onChanged: (newValue) {
          setState(() {
            valueChoose = newValue;
            if (newValue == dropDownList.elementAt(0)) {
              durationDays = 0;
            }
            if (newValue == dropDownList.elementAt(1)) {
              durationDays = list.length - 7;
            }
            if (newValue == dropDownList.elementAt(2)) {
              durationDays = list.length - 30;
            }
            print(durationDays);
          });
        },
        items: dropDownList.map(
          (value) {
            return DropdownMenuItem(
              child: Text(value),
              value: value,
            );
          },
        ).toList(),
      ),
    );
  }
}
