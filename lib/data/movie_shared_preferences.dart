import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';


Future<List<String>> getSearchHistory() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList("search_history");
}

Future<bool> addSearchHistory(String history) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> list = prefs.getStringList("search_history");
  if(list == null ){
    list = [];
  }
  if(list.contains(history)){
    list.remove(history);
  }
  list.add(history);
  prefs.setStringList("search_history", list);
  return true;
}

Future<bool> clearSearchHistory() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> list = [];
  prefs.setStringList("search_history", list);
  return true;
}