import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class HttpRequest extends ChangeNotifier {
  var countries;
  List fetchedCountries = [] ;
  var isRefreshed = false ;



  Future<void> getCountries() async {
    final url = "http://37.156.29.51:4450/api/countries";
    var response = await http.get(Uri.parse(url),
        headers: <String, String>{'token': 'NeRreatrfpEAEiNuR5RYuxOxgigp6PFX'});
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var entities = jsonData['data']['countries'];
      for (int i = 0; i < (entities as List).length; i++) {
         // print(entities[i]['name']);
        fetchedCountries.add(entities[i]['name']);
        // print(fetchedCountries);
        // isRefreshed != isRef ;

      }
    }

    // print(response.statusCode);
    notifyListeners();
  }


  List<String> get fetchedCountry{

    return [...fetchedCountries] ;
  }

}
