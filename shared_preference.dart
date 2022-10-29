import 'package:shared_preferences/shared_preferences.dart';
class SharedPref{
    late SharedPreferences prefs;

    getInstance() async {
      prefs = await SharedPreferences.getInstance();
    }

    setPref({name,value}) async {
      getInstance();
      await prefs.setInt(name, value);
    }

    getPref({name}){
      return prefs.getInt(name);
    }



}