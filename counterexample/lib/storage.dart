import 'package:shared_preferences/shared_preferences.dart';

class CounterStorage {
  SharedPreferences? prefs;
  CounterStorage();

  Future<int> readCounter() async {
    prefs ??= await SharedPreferences.getInstance();
    return prefs!.getInt('counter') ?? 0;
    // int? toReturn = prefs.getInt('counter');
    // if (toReturn == null) {
    //   return 0;
    // }
    // return toReturn;
  }

  Future<void> writeCounter(int counter) async {
    prefs ??= await SharedPreferences.getInstance();
    prefs!.setInt('counter', counter);
    // write to the file
  }
}
