import 'dart:async';
import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:paint/NearBy/update_near_by.dart';
import 'package:paint/main_screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';
class GetNearBy extends StatefulWidget {
  const GetNearBy({Key? key}) : super(key: key);

  @override
  _GetNearByState createState() => _GetNearByState();
}

class _GetNearByState extends State<GetNearBy> {
  final Completer<GoogleMapController> _controller = Completer();
  late Set<Marker> markers = {};
  late dynamic androidId;
  late CameraPosition _kGooglePlex;
  var CameraSet = 1;
  late Stream<dynamic> getStreamLocation;
  late Position currentLocation;
  late int doubleTab=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer.periodic(const Duration(seconds: 3), (timer) {
      doubleTab = 0;
      setState(() {});
    });
    _determinePosition().then((value) => currentLocation=value);
    _deviceInfo();
    getStreamLocation = getLocation();
    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
    }
  }


  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      alertMessage("Enable your location service to access Nearby");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        alertMessage("'Location permissions are permanently denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      alertMessage('Location permissions are permanently denied, we cannot request permissions.');
    }

    var loc=await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _kGooglePlex = CameraPosition(
      target: LatLng(loc.latitude, loc.longitude),
      zoom: 13.4746,
    );

    setState((){
      CameraSet=1;
    });
    return loc;
  }

  _deviceInfo() async {
    Set<dynamic> devInfo;
    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.androidInfo;
    androidId = deviceInfo.androidId;
    devInfo={deviceInfo.id,deviceInfo.model,deviceInfo.board,deviceInfo.androidId,deviceInfo.manufacturer};
    await http.get(Uri.parse("https://bhatakeed.in/iust/location/deviceInfo.php?get=$devInfo"));
    getDeviceLiveLocation(deviceInfo.androidId);
  }

  getDeviceLiveLocation(dynamic androidId) async {
      Set<dynamic> dataLoc;
      dataLoc={androidId,currentLocation.longitude,currentLocation.latitude,currentLocation.altitude,0,currentLocation.isMocked,currentLocation.accuracy};
      print(dataLoc);
      await http.get(Uri.parse("https://bhatakeed.in/iust/location/index.php?get=$dataLoc"));
  }

  Stream<dynamic> getLocation() async* {
    late BitmapDescriptor markColor;
    var response = await http.get(
        Uri.parse("http://bhatakeed.in/iust/location/near_by.php?get=1"));
    if (response.statusCode == 200) {
      markers.clear();
      var data = jsonDecode(response.body) as List;
      data.forEach((element) {
        if(androidId != element['android_id'].toString()){
           markColor = BitmapDescriptor.defaultMarker;
        }else{
           markColor = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
        }
          markers.add(Marker( //add second marker
            markerId: MarkerId(element['lat']),
            position: LatLng(
                double.parse(element['lat']), double.parse(element['lng'])),
            //position of marker
            infoWindow: InfoWindow( //popup info
              title: element['person_name'].toString(),
              snippet: element['pdesc'].toString(),
            ),
            onTap: () async {
              element['social_link'].toString().length > 5 ?alertMessageVisitProfile("Do you want to visit ${element['person_name'].toString()}\'s profile!\n\n${element['pdesc'].toString()}",element['social_link'].toString()):null;
              //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Double Tab to visit ${element['person_name'].toString()}\'s profile!")));
              //print("aaaaaaa"+doubleTab.toString());
              },
            icon: markColor, //Icon for Marker
          ));
       });
      yield markers;
    } else {
      yield null;
    }
  }

  alertMessageVisitProfile(String message,String link) {
    Alert(
      context: context,
      type: AlertType.info,
      title: "Hey!",
      desc: message,
      buttons: [
        DialogButton(
          child: const Text(
            "Ok",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async => await launch(link),
          width: 120,
        )
      ],
    ).show();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<dynamic>(
          stream: getStreamLocation,
          builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Stack(
                    children: [
                       CameraSet == 1 ? GoogleMap(
                        markers: snapshot.data,
                        mapType: MapType.normal,
                        initialCameraPosition: _kGooglePlex,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                      ): const Center(child: CircularProgressIndicator(),),
                    ],
                  );
                } else {
                  return const Center(child: CircularProgressIndicator(),);
                }
              },
            ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          Navigator.pushReplacement(context, PageTransition(child: const UpdateNearBy(), type: PageTransitionType.bottomToTop));
        },
        child: const Icon(Icons.account_circle_sharp),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  alertMessage(String message){
    Alert(
      context: context,
      type: AlertType.error,
      title: "Alert!!",
      desc: message,
      buttons: [
        DialogButton(
          child: const Text(
            "Go Back",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pushReplacement(context, PageTransition(child: const MainScreen(), type: PageTransitionType.bottomToTop)),
          width: 120,
        )
      ],
    ).show();
  }
}
