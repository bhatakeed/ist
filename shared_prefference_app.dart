import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefData{


  ///user profile
  Future<bool> setProfileName({required String name}) async {
   SharedPreferences sp = await SharedPreferences.getInstance();
   return sp.setString('profileName', name);
  }

  Future<String?> getProfileName() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('profileName');
  }

  //lock
  Future<bool> setPopUpLockMsg(value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.setBool('lockAvMsg', value);
  }

  Future<bool> getPopUpLockMsg() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getBool('lockAvMsg')!;
  }

  Future<bool> setLock(value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.setBool('lock', value);
  }

  Future<bool> getLock() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getBool('lock')!;
  }

}