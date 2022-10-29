import 'dart:async';
import 'dart:convert';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:paint/fetch_from.dart';

// ignore: must_be_immutable
class FullMap extends StatefulWidget {

  FullMap({Key? key}) : super(key: key);

  @override
  _FullMapState createState() => _FullMapState();
}

class _FullMapState extends State<FullMap> {
  final Completer<GoogleMapController> _controller = Completer();
  CustomInfoWindowController customInfoWindowController =
  CustomInfoWindowController();
  late Set<Marker> markers = {};
  late CameraPosition _kGooglePlex;
  Location location = Location();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
    }
    _kGooglePlex = const CameraPosition(
      target: LatLng(33.9262514,75.0192362),
      zoom: 17.00,
    );
  }

  Future<dynamic> getLocation() async {
    markers.clear();
    FetchFrom get = FetchFrom(url: "map.php");
    var data = jsonDecode(await get.GetData())['data'];
    data.forEach((dynamic element){
      markers.add(Marker(
        //icon: await BitmapDescriptor.fromAssetImage(const ImageConfiguration(devicePixelRatio: 3.2),"assets/images/marker.png"), //add second marker
        markerId: MarkerId(element['lat']),
        position:
        LatLng(double.parse(element['lat']), double.parse(element['long'])),
        onTap: () {
          customInfoWindowController.addInfoWindow!(
              buildingDetails(element: element),
              LatLng(
                  double.parse(element['lat']), double.parse(element['long'])));
        },
      ));
    });

    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getLocation(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Stack(children: [
              GoogleMap(
                markers: markers,
                mapType: MapType.hybrid,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  customInfoWindowController.googleMapController = controller;
                },
                onTap: (position){
                  customInfoWindowController.hideInfoWindow!();
                },
              ),
              CustomInfoWindow(
                controller: customInfoWindowController,
                height: 180,
                width: 250,
                offset: 50,
              ),
            ]);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

// ignore: camel_case_types
class buildingDetails extends StatelessWidget {
  const buildingDetails({
    Key? key,
    required this.element,
  }) : super(key: key);

  final Map element;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color:Colors.grey),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 250,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
              image: DecorationImage(
                image: NetworkImage(element['img']),
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FittedBox(child: FittedBox(child: Text(element['title'],style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold),))),
                const SizedBox(height: 2,),
                FittedBox(child: Text(element['email'],style: GoogleFonts.aBeeZee(fontSize: 11,),)),
                const SizedBox(height: 2,),
                FittedBox(child: Text(element['Desc'],style: GoogleFonts.aBeeZee(fontSize: 10),)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
