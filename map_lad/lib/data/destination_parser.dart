import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:http/http.dart' as http;
//RELEVANT TUTORIAL http://cogitas.net/parse-json-dart-flutter/

//Creation of a future method that returns a string from the json data
Future<String> _loadDestinationAsset() async {
  //We might be able to put the google string in place of the file path.
  //robot is cancer
  print("AAA");
  final response = await http.get('https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=WXLR%20Building%20Arizona%20State%20University&inputtype=textquery&fields=photos,formatted_address,name,rating,opening_hours,geometry&key=AIzaSyAfiqIZIhgw4mjdaH5eo4yfNuFYHdKlevg');
  //return await rootBundle.loadString('https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=WXLR%20Building%20Arizona%20State%20University&inputtype=textquery&fields=photos,formatted_address,name,rating,opening_hours,geometry&key=AIzaSyAfiqIZIhgw4mjdaH5eo4yfNuFYHdKlevg');

  return response.body;
}

//Entry point method to access the json file and the parser for the string.
/*
Future loadCrossword() async {
  String jsonCrossword = await _loadCrosswordAsset();
  _parseJsonForCrossword(jsonCrossword);
  //Printline to make sure json file is properly parsed.
  print(jsonCrossword);
}
*/

//Parses json string to a Map using dart convert
/*void _parseJsonForCrossword(String jsonString) {
  Map decoded = jsonDecode(jsonString);

  //Prints the 'name' section of the json by accessing its key in the Map object
  String name = decoded['name'];
  print("MAP THINGS HERE");
  print(name);

  //Accesses id section of json by accessing its map key.
  int id = decoded['id'];
  print(id.toString());

  //Across has multiple units within itself so we have to scan it as an array to access each member.
  for(var word in decoded['across']){
    print(word['number'].toString());
    print(word['word']);
  }
  print('ONLY FIRST ONE');
  print(decoded['across'][0]['number'].toString());
}*/

//Object representing our dataset object
class Destination {
  final double lat;
  final double lng;
  final String name;
  final String address;

  //Constructor setting instance variables to input values

  Destination(this.name,this.address,this.lat,this.lng);
}

 //Outputs a
  Destination _parseJsonForDestination(String jsonString) {
  Map decoded = jsonDecode(jsonString);

  //a word is an element in an across or an instance of an across?

  return new Destination(decoded['candidates'][0]['name'],decoded['candidates'][0]['formatted_address'],decoded['candidates'][0]['geometry']['location']['lat'],decoded['candidates'][0]['geometry']['location']['lng']);

  }

  //Loads the destination and allows it to be used.
  Future loadDestination() async {
  String jsonDestination = await _loadDestinationAsset();
  Destination destination = _parseJsonForDestination(jsonDestination);

    //Test printlines to verify destination is found
    print("TEST CASES HERE");
    print(destination.name);
    print(destination.address);
    print(destination.lat.toString());
    print(destination.lng.toString());
  }
  String getDestination(Map decodedJson){

  }
  Destination findDestination(/*String jsonPath*/) async{
    String jsonDestination = await _loadDestinationAsset();
    return _parseJsonForDestination(jsonDestination);
  }