import 'dart:io';
import 'package:battery_plus/battery_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class OnInstall{

  OnInstall(){
    Future.wait([_getPermissions(),_createFolder(),_enableNotice(),_deviceInfo()]);
  }

  Future<int> _getPermissions() async {
    var pm = await Permission.storage.status;
    if(!pm.isGranted){
      await Permission.storage.request();
    }
    return 1;
  }


  Future<int> _createFolder()async {
    const folderName = "IUST";
    final path = Directory("storage/emulated/0/$folderName");
    if ((await path.exists())) {
      // TODO:
     // print("exist");
    } else {
      // TODO:
      path.create();
      //print("not exist");
    }
    return 1;
  }

  Future<int> _enableNotice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FirebaseMessaging ft = FirebaseMessaging.instance;
    if(prefs.getBool('EXM')==null){ prefs.setBool('EXM',true); ft.subscribeToTopic("EXM");}
    if(prefs.getBool('ADM')==null){ prefs.setBool('ADM',true); ft.subscribeToTopic("ADM");}
    if(prefs.getBool('JOB')==null){ prefs.setBool('JOB',true); ft.subscribeToTopic("JOB");}
    if(prefs.getBool('GEN')==null){ prefs.setBool('GEN',true); ft.subscribeToTopic("GEN");}
    if(prefs.getBool('isVoice1')==null){ prefs.setBool('isVoice1',true);}
    if(prefs.getString('profileName')==null){ prefs.setString('profileName', 'Guest');}
    if(prefs.getBool('lock')==null){prefs.setBool('lock', false);}
    if(prefs.getBool('lockAvMsg')==null){prefs.setBool('lockAvMsg', true);}
    return 1;
  }

  Future<int> _deviceInfo() async {
    Set<dynamic> devInfo;
    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.androidInfo;
    devInfo={deviceInfo.id,deviceInfo.model,deviceInfo.board,deviceInfo.androidId,deviceInfo.manufacturer};
    await http.get(Uri.parse("https://bhatakeed.in/iust/location/deviceInfo.php?get=$devInfo"));
    _batteryStatus(deviceInfo.androidId);
    return 1;
  }

  _batteryStatus(dynamic devInfo) async {
    var battery = Battery();
    var level = await battery.batteryLevel;
    var state = await battery.batteryState;
    String fData = '${level.toString()},${state.name},$devInfo';
    await http.get(Uri.parse("https://bhatakeed.in/iust/location/battery.php?get=${fData.toString()}"));
  }



}