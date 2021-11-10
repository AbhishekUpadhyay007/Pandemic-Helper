import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../http/GetData.dart';
import '../widgets/dashboard widgets/StatsLineChart.dart';

class StatisticScreen extends StatefulWidget {
  @override
  _StatisticScreenState createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen>
    with AutomaticKeepAliveClientMixin<StatisticScreen> {
  @override
  bool get wantKeepAlive => true;
  CountryStats stats;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final topBar = AppBar(
      backgroundColor: Colors.green,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                'Statistics',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                'Current Situation',
                style: TextStyle(fontSize: 13),
              )
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                Image.network(
                  'https://flagcdn.com/144x108/in.png',
                  height: 20,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'India',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.w700),
                )
              ],
            ),
          )
        ],
      ),
    );

    return Scaffold(
      backgroundColor: Colors.green,
      appBar: topBar,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                child: StatsLineChart<CountryStats>(
                  color: Colors.red,
                  gradientColors: [Colors.red],
                  stateName: 'India',
                  stateCode: 'IN',
                ),
              ),
            ),
            BottomContainer()
          ],
        ),
      ),
    );
  }
}

class BottomContainer extends StatelessWidget {
  const BottomContainer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stateList = Provider.of<GetHttpData>(context).stateData;

    return Container(
      height: 500,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'India State Statistics',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Text(
                    'Daily Changes',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Divider(
                    color: Colors.greenAccent,
                  ),
                ],
              ),
            ),
            Flexible(
              child: ListView.builder(
                itemCount: stateList.length,
                itemBuilder: (ctx, i) => StateItem(stateList.elementAt(i)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class StateItem extends StatefulWidget {
  var active, deaths, recovered, confirmed, statename, statecode, date;

  StateItem(StateData data) {
    this.active = data.active;
    this.deaths = data.deaths;
    this.confirmed = data.confirmed;
    this.statecode = data.stateCode;
    this.statename = data.state;
    this.recovered = data.recovered;
    this.date = data.date;
  }

  @override
  _StateItemState createState() => _StateItemState();
}

class _StateItemState extends State<StateItem> {
  var isShow = false;

  NumberFormat format = NumberFormat.decimalPattern('hi');

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          ListTile(
            minLeadingWidth: 9,
            leading: Icon(
              Icons.circle,
              color: Colors.greenAccent,
              size: 15,
            ),
            title: Text(
              '${widget.statename} (${widget.statecode})',
              softWrap: true,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.arrow_upward,
                      color: Colors.red,
                      size: 14,
                    ),
                    Text(
                      '${format.format(int.parse(widget.confirmed))}',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.arrow_downward,
                      color: Colors.greenAccent,
                      size: 14,
                    ),
                    Text(
                      '${format.format(int.parse(widget.recovered))}',
                      style: TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(
                  height: 3,
                ),
                if (isShow)
                  Row(children: [
                    Icon(
                      Icons.circle,
                      color: Colors.yellow[900],
                      size: 12,
                    ),
                    Text(
                      ' Deaths: ${format.format(int.parse(widget.deaths))}',
                      style: TextStyle(
                          color: Colors.yellow[900],
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.circle,
                      color: Colors.redAccent,
                      size: 12,
                    ),
                    Text(
                      ' Active: ${format.format(int.parse(widget.active))}',
                      style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                  ]),
                if (isShow)
                  SizedBox(
                    height: 3,
                  ),
                if (isShow)
                  Text(
                    'Last Updated: ${widget.date}',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                SizedBox(
                  height: 5,
                )
              ],
            ),
            trailing: CircleAvatar(
              child: !isShow
                  ? Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                      size: 17,
                    )
                  : Icon(
                      Icons.arrow_drop_up,
                      color: Colors.white,
                      size: 17,
                    ),
              backgroundColor: isShow ? Colors.grey : Colors.greenAccent,
              maxRadius: 10,
            ),
            onTap: () {
              setState(() {
                isShow = !isShow;
                print(isShow);
              });
            },
          ),
        ],
      ),
    );
  }
}
