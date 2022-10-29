import 'dart:async';

import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:paint/constant.dart';
import 'package:paint/internet_check.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StudentLogin extends StatefulWidget {
  const StudentLogin({Key? key}) : super(key: key);

  @override
  _StudentLoginState createState() => _StudentLoginState();
}

class _StudentLoginState extends State<StudentLogin> {
  final LocalAuthentication auth = LocalAuthentication();
  String msg = "You are not authorized.";
  bool fingerPrint = false;
  bool isLogin = false;
  late bool isBiometricSupport;
  final Completer<WebViewController> _controller = Completer<
      WebViewController>();
  int loading = 0;
  String error = "";
  late String name="aa";
  bool _isLock = false;

  void readJS() async {
    Future<String> html = await _controller.future.then((value) =>
        value.evaluateJavascript(
            "window.document.getElementsByClassName('dropdown-toggle')[5].innerHTML;"));
    RegExp exp = RegExp(
        r'u003C|span|\\|class|\"|\/|>|\"|\=|caret', multiLine: true,
        caseSensitive: true);
    html.then((value) {
      name = value.replaceAll(exp, '');
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllSubscription();
  }


  _getAllSubscription() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await auth.canCheckBiometrics.then((value) {
      isBiometricSupport = value;
    });

    setState(() {
      _isLock = prefs.getBool('Lock')!;
    });
    if(_isLock ==true && isBiometricSupport == true){ finger(); }else{
      setState(() {
        fingerPrint = true;
      });
    }
  }

  void finger() async {
    bool pass = await auth.authenticate(
        localizedReason: 'Authenticate with Fingerprint',
    );

    setState(() {
      fingerPrint = pass;
    });
  }

  _setSubValues({type, value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(type, value);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        bottomNavigationBar:Stack(
          children: [
            isLogin == false ? SizedBox() : Row(
              children: [
                Switch(
                  value: _isLock,
                  onChanged: (value) {
                    setState((){
                      _isLock = value;
                      _setSubValues(type: "Lock",value: value);
                    });
                  },
                  activeTrackColor:  Constant.KSwitchColor,
                  activeColor: Constant.KSwitchColor,
                ),
                const Text("Biometric(Fingerprint) Lock",style: Constant.KTitleStyle,)
              ],
            ) ,
          ],
        ),
        appBar: AppBar(
          title: const Text("Student Login",),
          flexibleSpace: Constant.KFlexibleSpaceBar,
        ),
        body: Stack(
            children: [
              _isLock == true ? Center(child: ElevatedButton(
                onPressed: ()=>finger(),
                child: const Icon(Icons.fingerprint_outlined,size: 100,color: Colors.blue,),
              ),):const SizedBox(),
              error.isEmpty == true && fingerPrint == true  ? WebView(
                gestureNavigationEnabled: true,
                initialUrl: 'https://bhatakeed.in/iust/std.html',
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
                onPageFinished: (a) {
                  readJS();
                  if (a.toString() ==
                      "https://studentservice.iust.ac.in/Services/Default") {
                    print(a.toString());
                    setState(() {
                      isLogin = true;
                    });
                  }
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
              error.isEmpty == false ? Center(child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StudentLogin()),
                  );
                }, child: const Text("Reload"),
              ),): SizedBox(),
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
