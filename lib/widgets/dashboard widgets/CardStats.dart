import 'package:countup/countup.dart';
import 'package:covid/helper/StateAlias.dart';
import 'package:covid/http/LocationStats.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardStats extends StatelessWidget {
  final String countryCode;
  final String subAdmin, stateName;
  CardStats(this.countryCode, this.subAdmin, this.stateName);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> map;

    map = Provider.of<LocationStats>(context).districtData;

    if (map == null) {
      map = {'active': 2400, 'recovered': 40000, 'confirmed': 60000};
    }

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.red, width: 1.5),
        ),
        child: Container(
          padding: EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text('Your Location'),
                  Icon(
                    Icons.location_on,
                    color: Colors.red[600],
                    size: 20,
                  ),
                ],
              ),
              Divider(
                thickness: 1,
              ),
              ListTile(
                leading: Image.network(
                  'https://flagcdn.com/144x108/${countryCode == null ? 'in' : countryCode.toLowerCase()}.png',
                  width: 50,
                ),
                title: Text(
                  subAdmin,
                  style: Theme.of(context).textTheme.headline1,
                ),
                subtitle: Text(
                  '$stateName, India',
                  style: Theme.of(context).textTheme.headline6,
                ),
                trailing: Countup(
                  begin: 0,
                  end: double.parse(map['active'].toString()),
                  // duration: Duration(milliseconds: 1500),
                  suffix: '+\nactive',
                  style: TextStyle(
                      shadows: [
                        Shadow(
                            blurRadius: 3.55,
                            color: Colors.red[600],
                            offset: Offset.fromDirection(1))
                      ],
                      color: Colors.red[600],
                      fontSize: 19,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 70,
                    width: MediaQuery.of(context).size.width * .4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: [.1, .8],
                        colors: [Colors.redAccent, Colors.white],
                      ),
                    ),
                    child: ListTile(
                      leading: Image.asset(
                        'assets/images/graphred.png',
                        width: 40,
                      ),
                      title: Countup(
                        end: double.parse(map['confirmed'].toString()),
                        begin: 0,
                        // duration: Duration(milliseconds: 1500),
                        suffix: '+',
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      subtitle: Text(
                        'Confirmed',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 55,
                    color: Colors.grey,
                  ),
                  Container(
                    height: 70,
                    width: MediaQuery.of(context).size.width * .4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: [.1, .8],
                        colors: [Color.fromRGBO(51, 223, 89, 60), Colors.white],
                      ),
                    ),
                    child: ListTile(
                      leading: Image.asset(
                        'assets/images/graphgreen.png',
                        width: 40,
                      ),
                      title: Countup(
                        begin: 0,
                        end: double.parse(map['recovered'].toString()),
                        // duration: Duration(milliseconds: 1500),
                        suffix: '+',
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      subtitle: Text(
                        'Recovered',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
