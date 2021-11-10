import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as json;

class StateStats {
  final String cases;
  final String date;

  StateStats(this.cases, this.date);
}

class RecoveredStats {
  final String cases;
  final String date;

  RecoveredStats(this.cases, this.date);
}

class CountryStats {
  final String cases;
  final String date;
  final String totalRecover;
  final String totalConfirmed;
  final String totalDeaths;

  CountryStats(
      {this.cases,
      this.date,
      this.totalConfirmed,
      this.totalDeaths,
      this.totalRecover});
}

class StateData {
  final active;
  final confirmed;
  final deaths;
  final recovered;
  final state;
  final stateCode;
  final date;

  StateData(
      {this.active,
      this.confirmed,
      this.deaths,
      this.recovered,
      this.state,
      this.stateCode,
      this.date});
}

class GetHttpData with ChangeNotifier {
  List<StateStats> _confirmList = [];
  List<RecoveredStats> _recoveredList = [];
  List<CountryStats> _indiaStats = [];
  List<StateData> _stateData = [];

  List<RecoveredStats> get recoverList {
    return [..._recoveredList];
  }

  List<StateStats> get confirmedList {
    return [..._confirmList];
  }

  List<CountryStats> get countryStats {
    return [..._indiaStats];
  }

  List<StateData> get stateData {
    return [..._stateData];
  }

  Future<List<dynamic>> getStateWiseStats() async {
    try {
      final uri = Uri.parse('https://api.covid19india.org/states_daily.json');
      final response = await http.get(uri);
      Map data = json.jsonDecode(response.body);
      List confirmedData = data['states_daily'];
      return confirmedData;
    } catch (error) {
      print(error);
      return [];
    }
  }

  Future<void> getConfirmedStats(String stateCode) async {
    List confirmedData = [];
    confirmedData = await getStateWiseStats();
    confirmedData = confirmedData
        .where((element) => element['status'] == 'Confirmed')
        .toList();
    _confirmList.clear();
    confirmedData.forEach((element) {
      _confirmList.add(StateStats(element[stateCode], element['date']));
    });
    notifyListeners();
  }

  Future<void> getRecoverStats(String stateCode) async {
    List confirmedData = [];
    confirmedData = await getStateWiseStats();
    confirmedData = confirmedData
        .where((element) => element['status'] == 'Recovered')
        .toList();
    _recoveredList.clear();
    confirmedData.forEach((recover) {
      _recoveredList.add(RecoveredStats(recover[stateCode], recover['date']));
    });
    notifyListeners();
  }

  Future<void> getCountryData() async {
    try {
      _indiaStats.clear();
      final url = Uri.parse('https://api.covid19india.org/data.json');
      final response = await http.get(url);
      final fetchedData =
          json.jsonDecode(response.body) as Map<String, dynamic>;

      List<dynamic> data = fetchedData['cases_time_series'];
      // print(fetchedData['cases_time_series']);
      List<dynamic> statewise = fetchedData['statewise'];

      data.forEach((data) {
        final value = data as Map<String, dynamic>;
        _indiaStats.add(new CountryStats(
            cases: value['dailyconfirmed'],
            date: value['date'],
            totalConfirmed: value['totalconfirmed'],
            totalDeaths: value['totaldeceased'],
            totalRecover: value['totalrecovered']));
      });

      statewise.forEach((value) {
        final v = value as Map<String, dynamic>;
        _stateData.add(
          new StateData(
              active: v['active'],
              deaths: v['deaths'],
              recovered: v['recovered'],
              confirmed: v['confirmed'],
              state: v['state'],
              stateCode: v['statecode'],
              date: v['lastupdatedtime']),
        );
      });

      //print(_indiaStats);
    } catch (error) {
      print(error);
    }
  }
}
