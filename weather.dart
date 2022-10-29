import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'package:paint/constant.dart';
import 'package:weather/weather.dart';

class WeatherGet extends StatefulWidget {
  const WeatherGet({Key? key}) : super(key: key);

  @override
  State<WeatherGet> createState() => _WeatherGetState();
}

class _WeatherGetState extends State<WeatherGet> {
  WeatherFactory wf = WeatherFactory("94a388a9e3aac769cc985051e3965c1b");
  String temp = '';
  String icon = '03n';
  String desc = '';
  String areaName='';
  String humidity='';
  Location location = Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late Widget currentWeather = const Center(child: Text("Wait..."),);
  late bool isFirstEnable = false;
  String buttonText = "Get";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWeather();
    is_enable();
    //getLocation();
  }


  is_enable() async {
      location.serviceEnabled().then((value){
        setState((){
          isFirstEnable = value;
        });
        value == true ? getLocation():null;
      });
  }

  isServiceEnable() async {
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        currentWeather = const Center(child: Text("Permission Denied"),);
        setState((){
          buttonText = "Permission Denied";
        });
        return;
      }
    }
  }

  getLocation(){
    isServiceEnable();
    location.getLocation().then((value) async {
      buttonText = "Loading..";
      Weather _w = await wf.currentWeatherByLocation(value.latitude!,value.longitude!);
      setState((){
        currentWeather = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                "https://openweathermap.org/img/w/"+_w.weatherIcon!+".png",
                scale: 1.5,
              ),
            ),
            Text(_w.areaName.toString(),style:  GoogleFonts.kanit(fontSize: 12)),
            Text(_w.temperature!.celsius.toString().substring(0, 4)+" celsius",style:  GoogleFonts.kanit(fontSize: 12),),
            Text("Humidity: "+_w.humidity.toString(),style:  GoogleFonts.kanit(fontSize: 12)),
            Text("${_w.weatherDescription}",style:  GoogleFonts.kanit(fontSize: 12),),
          ],
        );
        isFirstEnable = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      key: UniqueKey(),
      elevation: 1.0,
      shadowColor: Constant.primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 15),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                radius: 10,
                colors: [
                  Colors.lightBlueAccent.withOpacity(0.5),
                  Colors.white,
                ]
              )
            ),
            child: Row(
                children:[
                  const Icon(Icons.calendar_view_day),
                  const SizedBox(width: 10,),
                  Text(
                    "Weather",
                    style: GoogleFonts.kanit(fontWeight: FontWeight.w400),
                  ),
                ]
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("IUST Campus",style: GoogleFonts.kanit(),),
              Text("Current Location",style: GoogleFonts.kanit())
            ],
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 5.0,bottom: 5.0,left: 45.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.network(
                          "https://openweathermap.org/img/w/"+icon+".png",
                          scale: 1.5,
                        ),
                      ),
                      Text(areaName.toString(),style: GoogleFonts.kanit(fontSize: 12)),
                      Text(temp.toString().substring(0, 4)+" celsius",style: GoogleFonts.kanit(fontSize: 12),),
                      Text("Humidity: "+humidity,style: GoogleFonts.kanit(fontSize: 12)),
                      Text(desc,style: GoogleFonts.kanit(fontSize: 12),),
                    ],
                  ),
                  const SizedBox(width: 60,),
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: 0.3,
                    height: 60,
                    color: Colors.lightBlueAccent,
                  ),
                  const SizedBox(width: 42,),
                  isFirstEnable ==true ?currentWeather:Center(child: TextButton(onPressed:(){
                    getLocation();
                  },child: Text(buttonText.toString()),),),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future getWeather() async {
    Weather w = await wf.currentWeatherByLocation(33.92, 75.01);

    setState(() {
      areaName = w.areaName!.toString();
      humidity = w.humidity!.toString();
      temp = w.temperature!.celsius!.toString();
      desc = w.weatherDescription!;
      icon = w.weatherIcon!;
    });

  }
}
