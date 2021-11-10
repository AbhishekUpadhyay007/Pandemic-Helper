import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as json;

class LocationStats with ChangeNotifier {
  Map<String, dynamic> _fetchedData;

  Map<String, dynamic> get districtData {
    return _fetchedData;
  }

  Future<void> fetchDistrictData(String district, String stateName) async {
    try {
      final url =
          Uri.parse('https://api.covid19india.org/state_district_wise.json');
      final response = await http.get(url);
      final loadedData = json.jsonDecode(response.body) as Map<String, dynamic>;

      _fetchedData = loadedData[stateName]['districtData'][district];
      print(_fetchedData);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
