import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:paint/constant.dart';
import 'package:paint/internet_check.dart';
import 'package:webview_flutter/webview_flutter.dart';

class UpdateNearBy extends StatefulWidget {
  const UpdateNearBy({Key? key}) : super(key: key);

  @override
  _UpdateNearByState createState() => _UpdateNearByState();
}

class _UpdateNearByState extends State<UpdateNearBy> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  int loading=0;
  String error='';
  final deviceInfoPlugin = DeviceInfoPlugin();
  dynamic android_id = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    androidIdGet();
  }

  androidIdGet() async {
    final deviceInfo = await deviceInfoPlugin.androidInfo;
    android_id = deviceInfo.androidId.toString().trim();
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Near By Profile",),
          flexibleSpace: Constant.KFlexibleSpaceBar,
        ),
        body: Stack(
            children:[
              error.isEmpty==true && android_id != 0 ? WebView(
                gestureNavigationEnabled: true,
                initialUrl: 'https://bhatakeed.in/iust/location/form.php?aid='+android_id,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController){
                  _controller.complete(webViewController);
                },
                onProgress: (int progress){
                  setState(() {
                    loading = progress;
                  });
                },
                onWebResourceError:(webResourceError){
                  setState(() {
                    error = webResourceError.description;
                  });
                  //print(error.isEmpty);
                },
              ) : Center(child: ElevatedButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UpdateNearBy()),
                  );
                }, child: const Text("Reload"),
              ),),
              loading != 100 ? const Center(child: CircularProgressIndicator(),) : const SizedBox(height: double.infinity,),
              error.isEmpty==true ? const SizedBox() : const InertnetCheck(),
            ]
        ),
      ),
    );
  }
}
