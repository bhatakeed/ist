import 'dart:async';

import 'package:flutter/material.dart';
import 'package:paint/constant.dart';
import 'package:paint/internet_check.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Result extends StatefulWidget {
  const Result({Key? key}) : super(key: key);

  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  int loading=0;
  String error='';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Result",),
          flexibleSpace: Constant.KFlexibleSpaceBar,
        ),
        body: Stack(
            children:[
              error.isEmpty==true ? WebView(
                gestureNavigationEnabled: true,
                initialUrl: 'https://bhatakeed.in/iust/result.html',
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
                  print(error.isEmpty);
                },
              ) : Center(child: ElevatedButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Result()),
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
