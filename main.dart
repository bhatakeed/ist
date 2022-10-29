import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paint/NearBy/get_near_by.dart';
import 'package:paint/about_university.dart';
import 'package:paint/admission_notice.dart';
import 'package:paint/constant.dart';
import 'package:paint/developer.dart';
import 'package:paint/examination_notice.dart';
import 'package:paint/favorite_notice.dart';
import 'package:paint/general_notice.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:paint/main_screen.dart';
import 'package:paint/on_install.dart';
import 'package:paint/recruitment_notice.dart';
import 'package:paint/result.dart';
import 'package:paint/setting.dart';
import 'package:paint/student_login.dart';
import 'package:paint/troubleshoot.dart';
import 'package:paint/video_gallery.dart';
import 'package:paint/weather.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  int.parse(message.data.values.first) == 1
      ? _isSpeekNotice(text: message.notification!.body.toString())
      : null;
}



main() async {
  SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle(
    statusBarColor: Constant.primaryColor,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  OneSignal.shared.setAppId("91b28fc0-07b8-4d66-b1bc-2c5ba8bc7a73");
  MobileAds.instance.initialize();
  runApp(MaterialApp(
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
    nextScreen: const MainScreen(),
    splash: 'assets/images/sp3.png',
    splashIconSize: 200.0,
    duration: 5,
    animationDuration: const Duration(seconds: 2),
    splashTransition: SplashTransition.fadeTransition,
    pageTransitionType: PageTransitionType.fade,
  )));

}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late InterstitialAd interstitialAd;
  @override
  void initState() {
    // TODO: implement initState
    //_speak("test");
    //OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OnInstall();
    super.initState();
    _createInterstitialAd();
    myBanner.load();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-2790734698265499/3564066912',
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          ad.show();
        },
        onAdFailedToLoad: (LoadAdError error) {
          _createInterstitialAd();
          //print("ade $error");
        },
      ),
    );
  }


  final BannerAd myBanner = BannerAd(
    adUnitId: 'ca-app-pub-2790734698265499/4875692009',
    size: AdSize.banner,
    request: const AdRequest(),
    listener: const BannerAdListener(),
  );

  @override
  void dispose() {
    myBanner.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Upgrader().isUpdateAvailable();
    return UpgradeAlert(
      child: DefaultTabController(
        initialIndex: 0,
        length: 4,
        child: Scaffold(
            bottomNavigationBar:
                SizedBox(height: 50, child: AdWidget(ad: myBanner)),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    child: null,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                          image: NetworkImage(
                              'https://bhatakeed.in/iust/imgs/1.jpg'),
                          fit: BoxFit.cover),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Constant.primaryColor,
                            Constant.primaryColor,
                            Colors.white70
                          ]),
                    ),
                  ),
                  ListTile(
                    title: const Text('About University'),
                    leading: Icon(
                      Icons.dashboard,
                      color: Constant.primaryColor,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: const AboutUniversity(),
                              type: PageTransitionType.bottomToTop));
                    },
                  ),
                  ListTile(
                    title: const Text('Student Login'),
                    leading: Icon(
                      Icons.login,
                      color: Constant.primaryColor,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: const StudentLogin(),
                              type: PageTransitionType.bottomToTop));
                    },
                  ),
                  ListTile(
                    title: const Text('Result'),
                    leading: Icon(
                      Icons.find_in_page,
                      color: Constant.primaryColor,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: const Result(),
                              type: PageTransitionType.bottomToTop));
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.star,
                      color: Constant.primaryColor,
                    ),
                    title: const Text('Favorites'),
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: const FavoriteNotice(),
                              type: PageTransitionType.topToBottom));
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.camera,
                      color: Constant.primaryColor,
                    ),
                    title: const Text('Video Gallery'),
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: const VideoGalley(),
                              type: PageTransitionType.topToBottom));
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      const IconData(0xe3ab, fontFamily: 'MaterialIcons'),
                      color: Constant.primaryColor,
                    ),
                    title: const Text('Nearby IUSTAN\'S'),
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: const GetNearBy(),
                              type: PageTransitionType.topToBottom));
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.developer_board,
                      color: Constant.primaryColor,
                    ),
                    title: const Text('Developer'),
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: const Developer(),
                              type: PageTransitionType.topToBottom));
                    },
                  ),
                  SizedBox(
                    child: Container(
                      color: Constant.primaryColor,
                      height: 0.5,
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.error_sharp,
                      color: Constant.primaryColor,
                    ),
                    title: const Text('Troubleshoot'),
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: const Troubleshoot(),
                              type: PageTransitionType.topToBottom));
                    },
                  ),
                  SizedBox(
                    child: Container(
                      color: Constant.primaryColor,
                      height: 0.5,
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.share,
                      color: Constant.primaryColor,
                    ),
                    title: const Text('Share'),
                    onTap: () async {
                      await Share.share(
                          "Click to Download IUST APP. \n https://play.google.com/store/apps/details?id=com.bhatakeed.iust",
                          subject: "Download IUST APP.");
                    },
                  ),
                  ListTile(
                    title: const Text('Close'),
                    leading: Icon(
                      Icons.close,
                      color: Constant.primaryColor,
                    ),
                    onTap: () {
                      Navigator.of(context).maybePop();
                    },
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  const WeatherGet(),
                ],
              ),
            ),
            appBar: AppBar(
              actions: [
                PopupMenuButton(
                  onSelected: (value) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Setting()));
                  },
                  padding: const EdgeInsets.all(1.0),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      child: Text("Setting"),
                      value: 1,
                    ),
                  ],
                ),
              ],
              elevation: 4,
              shadowColor: Constant.primaryColor,
              titleSpacing: 8,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Constant.primaryColor,
                        Constant.primaryColor,
                        Colors.white70
                      ]),
                ),
              ),
              centerTitle: true,
              title: FittedBox(
                  child: Text(
                "Islamic University of Science & Technology",
                style: Constant.headerFont,
              )),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50.0),
                child: SizedBox(
                  height: 30,
                  child: TabBar(
                    indicatorColor: Constant.indTabColor,
                    indicatorWeight: 2.5,
                    indicatorSize: TabBarIndicatorSize.label,
                    isScrollable: false,
                    labelColor: Constant.indTabColor,
                    unselectedLabelColor: Colors.white,
                    tabs: [
                      FittedBox(
                          child: Text(
                        "General",
                        style: Constant.tabsTextStyle.copyWith(fontSize: 12),
                      )),
                      FittedBox(
                          child: Text(
                        "Examination",
                        style: Constant.tabsTextStyle,
                      )),
                      FittedBox(
                          child: Text(
                        "Admissions",
                        style: Constant.tabsTextStyle,
                      )),
                      FittedBox(
                          child: Text(
                        "Recruitment",
                        style: Constant.tabsTextStyle,
                      ))
                    ],
                  ),
                ),
              ),
            ),
            body: Container(
              padding: const EdgeInsets.only(top: 6),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: const TabBarView(
                children: [
                  GeneralNotice(),
                  ExaminationNotice(),
                  AdmissionNotice(),
                  RecrumentNotice(),
                ],
              ),
            )),
      ),
    );
  }
}

_isSpeekNotice({text}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? isVoice = prefs.getBool('isVoice1');
  isVoice == true ? readNotice(text: text) : null;
}

readNotice({text}) {
  if (text == null) {
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      if (int.parse(event.notification.additionalData!.values.first) == 1) {
        _speak(event.notification.body.toString());
      }
    });
    OneSignal.shared.setNotificationOpenedHandler((openedResult) {
      if ((int.parse(openedResult.notification.additionalData!.values.first)) ==
          1) {
        _speak(openedResult.notification.body.toString());
      }
    });
  } else {
    _speak(text);
  }
}

Future _speak(String text) async {
  final FlutterTts _flutterTts = FlutterTts();
  await _flutterTts.setLanguage("en-AU");
  await _flutterTts.setSpeechRate(0.4);
  await _flutterTts.setPitch(1.0);
  if (text.isNotEmpty) {
    var result = await _flutterTts.speak(text);
    if (result == 1) {}
  }
}
