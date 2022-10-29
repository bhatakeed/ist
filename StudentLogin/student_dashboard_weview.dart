import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paint/StudentLogin/student_dashboard.dart';
import 'package:paint/constant.dart';
import 'package:paint/internet_check.dart';
import 'package:paint/shared_prefference_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:html/dom.dart' as dom;

import '../student_login.dart';

class StudentLoginWebview extends StatefulWidget {
  dynamic url;

  StudentLoginWebview(this.url, {Key? key}) : super(key: key);

  @override
  _StudentLoginWebviewState createState() => _StudentLoginWebviewState();
}

class _StudentLoginWebviewState extends State<StudentLoginWebview> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  final SharedPrefData sp = SharedPrefData();
  late dynamic controller;
  int loading = 0;
  String error = '';

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Student Dashboard",
          ),
          flexibleSpace: Constant.KFlexibleSpaceBar,
        ),
        body: Stack(children: [
          error.isEmpty == true
              ? WebView(
                  gestureNavigationEnabled: false,
                  initialUrl: widget.url,
                  javascriptChannels: <JavascriptChannel>{
                    // Set Javascript Channel to WebView
                    _extractDataJSChannel(context),
                  },
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                    controller = webViewController;
                  },
                  onPageStarted: (_) {
                    _controller.future.then((value) => value.evaluateJavascript("document.getElementsByClassName(\"navbar-fixed-top\")[0].style.display='none';"));
                  _controller.future.then((value) => value.evaluateJavascript("document.getElementsByClassName(\"footer\")[0].style.display='none';"));
                  },
                  onPageFinished: (String url) async {
                    styleLogin(_controller);
                    readJS();
                    dom.Document html = parse(jsonDecode(
                        await controller.evaluateJavascript(
                            "window.document.getElementsByTagName('html')[0].innerHTML;")));
                    var links = html
                        .querySelector('.dropdown-menu >li >a')!
                        .attributes['href'];
                    if (url ==
                        "https://studentservice.iust.ac.in/Services/Default.aspx") {
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              child: StudentDashboard('', links),
                              type: PageTransitionType.bottomToTop));
                    }
                  },
                  navigationDelegate: (NavigationRequest request) {
                    if(request.url.toString()=="https://studentservice.iust.ac.in/Services/Default"){
                    //Navigator.push(context, PageTransition(child: const StudentDashboard(), type: PageTransitionType.bottomToTop));
                  }else if(request.url.toString()=="https://studentservice.iust.ac.in/Services/Default.aspx"){
                    //Navigator.push(context, PageTransition(child: const StudentDashboard(), type: PageTransitionType.bottomToTop));
                  }
                    return NavigationDecision.navigate;
                  },
                  onProgress: (int progress) {
                    setState(() {
                      loading = progress;
                    });
                  },
                  onWebResourceError: (webResourceError) {
                    setState(() {
                      error = webResourceError.description;
                    });
                    //print(error.isEmpty);
                  },
                )
              : Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => StudentLogin()),
                      );
                    },
                    child: const Text("Reload"),
                  ),
                ),
          loading != 100
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : const SizedBox(
                  height: double.infinity,
                ),
          error.isEmpty == true ? const SizedBox() : const InertnetCheck(),
        ]),
      ),
    );
  }

  void readJS() async {
    Future<String> html = await _controller.future.then((value) =>
        value.runJavascriptReturningResult(
            "window.document.getElementsByClassName('dropdown-toggle')[5].innerHTML;"));
    RegExp exp = RegExp(r'u003C|span|\\|class|\"|\/|>|\"|\=|caret',
        multiLine: true, caseSensitive: true);
    html.then((value) async {
      sp.setProfileName(name: value.replaceAll(exp, ''));
    });
  }
}

Future<void> styleLogin(_controller) async {
  _controller.future.then((value) => value.evaluateJavascript(
          "document.getElementsByTagName(\"h2\")[0].style.display='none';"
          "document.getElementsByTagName(\"p\")[0].className = 'alert alert-danger';"
          "document.getElementsByTagName(\"h2\")[0].style.display='none';"
          "document.getElementsByClassName(\"navbar-fixed-top\")[0].style.display='none';"
          "document.getElementsByClassName(\"footer\")[0].style.display='none';"
          "document.getElementsByClassName(\"btn\")[1].style.display='none';"
          "document.getElementsByClassName(\"btn\")[0].style.width='100%';"
          "document.getElementById(\"socialLoginForm\").style.display='none';"
          "document.getElementById(\"viewSwitcher\").style.display='none';"));
}

JavascriptChannel _extractDataJSChannel(BuildContext context) {
  return JavascriptChannel(
    name: 'Flutter',
    onMessageReceived: (JavascriptMessage message) {
      String pageBody = message.message;
      print('page body: $pageBody');
    },
  );
}
