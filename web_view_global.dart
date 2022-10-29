import 'dart:async';
import 'package:flutter/material.dart';
import 'package:paint/constant.dart';
import 'package:paint/internet_check.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewGlobal extends StatefulWidget {
  String title;
  String url;
  WebViewGlobal({Key? key,required this.title,required this.url}) : super(key: key);

  @override
  _WebViewGlobalState createState() => _WebViewGlobalState();
}

class _WebViewGlobalState extends State<WebViewGlobal> {

  bool isLogin = false;
  final Completer<WebViewController> _controller = Completer<
      WebViewController>();
  int loading = 0;
  String error = "";
  late String name="aa";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title,),
          flexibleSpace: Constant.KFlexibleSpaceBar,
        ),
        body: Stack(
            children: [
              error.isEmpty == true ? WebView(
                gestureNavigationEnabled: true,
                initialUrl: widget.url,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
                onPageFinished: (a) {
                },
                navigationDelegate: (NavigationRequest request) {

                  return NavigationDecision.navigate;
                },
                onProgress: (int progress) {
                  setState(() {
                    loading = progress;
                  });
                  print(loading);
                },
                onWebResourceError: (webResourceError) {
                  setState(() {
                    error = webResourceError.description;
                  });
                  // print(error.isEmpty);
                },
              ) : SizedBox(),
              loading != 100
                  ? const Center(child: CircularProgressIndicator(),)
                  : const SizedBox(height: double.infinity,),
              error.isEmpty == true ? const SizedBox() : const InertnetCheck(),

            ]
        ),
      ),
    );
  }
}
