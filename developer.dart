import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:paint/constant.dart';
import 'package:paint/fetch_from.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Developer extends StatefulWidget {
  const Developer({Key? key}) : super(key: key);

  @override
  _DeveloperState createState() => _DeveloperState();
}

class _DeveloperState extends State<Developer> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    FetchFrom get = FetchFrom(url: "developerMessage.json");
    var data = jsonDecode(await get.GetData());

    Future.delayed(const Duration(seconds: 2),(){
      data['status'].toString() == "1" ?  _speak(data['message'].toString()) : null;
    });

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          flexibleSpace: Constant.KFlexibleSpaceBar,
          title: const Text("Developer"),
        ),
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Card(
                elevation: 2.0,
                shadowColor: Constant.primaryColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Designed & Developed By",
                      style: Constant.headerFont.copyWith(fontSize: 20.0),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Akeed Hussain Bhat",
                      style: Constant.KTitleStyle.copyWith(fontSize: 20.0),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Constant.primaryColor,
                      backgroundImage: const NetworkImage(
                          'https://bhatakeed.in/iust/imgs/profile.jpg'),
                    ),
                    const SizedBox(height:20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(child: SvgPicture.asset('assets/images/icons8-facebook.svg',width: 35,height: 35,),onTap: () async {
                          await launch('https://www.facebook.com/bhatakeed');
                        },),
                        const SizedBox(width: 15,),
                        GestureDetector(child: SvgPicture.asset('assets/images/icons8-instagram.svg',width: 35,height: 35,),onTap: () async {
                          await launch('https://www.instagram.com/bhatakeed/?hl=en');
                        },),
                        const SizedBox(width: 15,),
                        GestureDetector(child: SvgPicture.asset('assets/images/icons8-gmail.svg',width: 35,height: 35,),onTap: () async {
                          await launch('mailto:bhatakeed@gmail.com');
                        },),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future _speak(String text) async {
  final FlutterTts _flutterTts = FlutterTts();
  //var i = await _flutterTts.getVoices;
  //i.forEach((c)=>print(c));
  await _flutterTts.setVoice({"name": "hi-in-x-hid-network", "locale": "hi-IN"});
  await _flutterTts.setSpeechRate(0.4);
  await _flutterTts.setPitch(1.0);
  if (text.isNotEmpty) {
    var result = await _flutterTts.speak(text);
    if (result == 1) {}
  }
}