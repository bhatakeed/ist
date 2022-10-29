import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
class InertnetCheck extends StatefulWidget {
  const InertnetCheck({Key? key}) : super(key: key);

  @override
  State<InertnetCheck> createState() => _InertnetCheckState();
}

class _InertnetCheckState extends State<InertnetCheck> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future:checkInternet(),builder: (ctx , snapshot){
       if(snapshot.hasData){
         return Container(color: Colors.white,width: double.infinity,child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Image.asset("assets/images/no_internet.jpg"),
             const Text("No Internet Connection !",style: TextStyle(fontSize:25,fontFamily: 'Schyler',color: Colors.red)),
           ],
         ));
       }else{
         return Stack();
       }

    });
  }

  Future<dynamic>checkInternet() async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {

    });
    if (connectivityResult == ConnectivityResult.none) {
      return 1;
    }else{
      return null;
    }
  }
}


