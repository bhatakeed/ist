import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:paint/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool isSwitched = false;
  bool _isVoice = false;
  bool _isExam = false;
  bool _isAdmission = false;
  bool _isRecrument = false;
  bool _isGen = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //isSubs();
    _getAllSubscription();
  }

  isSubs() async {
    await OneSignal.shared.getDeviceState().then((deviceState) {
      setState(() {
        isSwitched = deviceState!.subscribed;
      });
    });
  }

  _getAllSubscription() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _isVoice = prefs.getBool('isVoice1')!;
        _isAdmission = prefs.getBool('ADM')!;
        _isExam = prefs.getBool('EXM')!;
        _isRecrument =    prefs.getBool('JOB')!;
        _isGen = prefs.getBool('GEN')!;
      });
  }

  _setSubValues({type, value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(type, value);
    value==true?
    FirebaseMessaging.instance.subscribeToTopic(type)
    :
    FirebaseMessaging.instance.unsubscribeFromTopic(type);
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text("Setting"),
        flexibleSpace: Constant.KFlexibleSpaceBar,
      ),
      body: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Column(
              children: [
                 Center(child: Text("Receive Notifications",style: Constant.KTitleStyle.copyWith(fontSize: 15))),
                Row(
                  children: [
                    Switch(
                      value: _isGen,
                      onChanged: (value) {
                        setState((){
                          _isGen = value;
                          _setSubValues(type: "GEN",value: value);
                        });
                      },
                      activeTrackColor:  Constant.KSwitchColor,
                      activeColor: Constant.KSwitchColor,
                    ),
                    const Text("General",style: Constant.KTitleStyle,)
                  ],
                ),
                Row(
                  children: [
                    Switch(
                      value: _isExam,
                      onChanged: (value) {
                        setState((){
                          _isExam = value;
                          _setSubValues(type: "EXM",value: value);
                           });
                      },
                      activeTrackColor:  Constant.KSwitchColor,
                      activeColor: Constant.KSwitchColor,
                    ),
                    const Text("Examination",style: Constant.KTitleStyle,)
                  ],
                ),
                Row(
                  children: [
                    Switch(
                      value: _isAdmission,
                      onChanged: (value) {
                        setState((){
                          _isAdmission = value;
                          _setSubValues(type: "ADM",value: value);
                        });
                      },
                      activeTrackColor:  Constant.KSwitchColor,
                      activeColor: Constant.KSwitchColor,
                    ),
                    const Text("Admission",style: Constant.KTitleStyle,)
                  ],
                ),
                Row(
                  children: [
                    Switch(
                      value: _isRecrument,
                      onChanged: (value) {
                        setState((){
                          _isRecrument = value;
                          _setSubValues(type: "JOB",value: value);
                        });
                      },
                      activeTrackColor:  Constant.KSwitchColor,
                      activeColor: Constant.KSwitchColor,
                    ),
                    const Text("Recruitment",style: Constant.KTitleStyle,)
                  ],
                ),
              ],
            ),
            Container(color: Colors.blue,height: 0.5,),
            Row(
              children: [
                Switch(
                  value: _isVoice,
                  onChanged: (value) {
                    setState(() {
                      _isVoice = value;
                      _setSubValues(type: "isVoice1",value: value);

                    });

                  },
                  activeTrackColor: Constant.KSwitchColor,
                  activeColor: Constant.KSwitchColor,
                ),
                const Text("Auto Read Important Notifications",style: Constant.KTitleStyle,)
              ],
            ),
          ],
        ),
      )
    ));
  }
}


