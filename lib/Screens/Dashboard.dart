import 'package:flutter/material.dart';
import '../http/GetData.dart';

import '../widgets/dashboard widgets/CardStats.dart';
import '../widgets/dashboard widgets/ImageCarousel.dart';
import '../widgets/dashboard widgets/StatsLineChart.dart';

class DashboardScreen extends StatefulWidget {
  static final routeName = './Dashboard';
  DashboardScreen(
      {this.countryCode, this.stateCode, this.statename, this.subAdmin});

  final countryCode;
  final statename;
  final stateCode;
  final subAdmin;

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with AutomaticKeepAliveClientMixin<DashboardScreen> {
  final List<Color> gradientConfirmedColors = [Colors.red[400], Colors.red];

  final List<Color> gradientRecoveredColors = [
    Colors.green[800],
    Colors.green[900],
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageCarousel(widget.statename),
            widget.countryCode == null
                ? Container()
                : CardStats(
                    widget.countryCode, widget.subAdmin, widget.statename),
            Divider(
              thickness: 1,
            ),
            StatsLineChart<StateStats>(
              color: Colors.red[400],
              gradientColors: gradientConfirmedColors,
              stateCode: widget.stateCode,
              stateName: widget.statename,
            ),
            StatsLineChart<RecoveredStats>(
              color: Color.fromRGBO(51, 223, 89, .8),
              gradientColors: gradientRecoveredColors,
              stateCode: widget.stateCode,
              stateName: widget.statename,
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
