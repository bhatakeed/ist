import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:paint/internet_check.dart';

class InternetConnection extends StatefulWidget {
  const InternetConnection({Key? key}) : super(key: key);

  @override
  _InternetConnectionState createState() => _InternetConnectionState();
}

class _InternetConnectionState extends State<InternetConnection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: internetConnectivity(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            return const InertnetCheck();
          }else{
            return const Center(child:CircularProgressIndicator());
          }
        },
      ),
    );
  }


  Future<dynamic> internetConnectivity() async{
    setState(() {

    });
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return 1;
    } else {
      return null;
    }

  }
}


