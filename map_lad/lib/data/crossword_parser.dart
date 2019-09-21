import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
//RELEVANT TUTORIAL http://cogitas.net/parse-json-dart-flutter/

//Creation of a future method that returns a string from the json data
Future<String> _loadCrosswordAsset() async {
  //We might be able to put the google string in place of the file path.
  //robot is cancer
  return await rootBundle.loadString('assets/data/crossword.json');
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
class Crossword {
  final int id;
  final String name;
  final Across across;
  //Constructor setting instance variables to input values
  Crossword(this.id,this.name,this.across);
}
 class Across {
  final List<Word> words;

  const Across(this.words);
 }
 class Word {
  final int number;
  final String word;

  const Word(this.number,this.word);
 }

 //Outputting a Crossword from the parse method
  Crossword _parseJsonForCrossword(String jsonString) {
  Map decoded = jsonDecode(jsonString);

  //a word is an element in an across or an instance of an across?
  List<Word> words = new List<Word>();
  for (var word in decoded['across']) {
    words.add(new Word(word['number'], word['word']));
  }

  return new Crossword(decoded['id'], decoded['name'], new Across(words));
  }

  //New version of load crossword that uses the object method of crossword building.
  Future loadCrossword() async {
  String jsonCrossword = await _loadCrosswordAsset();
  Crossword crossword = _parseJsonForCrossword(jsonCrossword);

  //We check if it's working
    print(crossword.name);

    //Crossword is loaded from JSON, do what you want with it now B)
    print("TEST CASES HERE");
    //outputs the number of the second instance of across.
    print(crossword.across.words[1].number);
  }