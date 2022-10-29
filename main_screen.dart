import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paint/Chat/chat.dart';
import 'package:paint/Storey/storey.dart';
import 'package:paint/StudyMaterial/studymaterial.dart';
import 'package:paint/Syllabus/departments.dart';
import 'package:paint/downloads.dart';
import 'package:paint/fetch_from.dart';
import 'package:paint/front_card_flip.dart';
import 'package:paint/iust_events.dart';
import 'package:paint/on_install.dart';
import 'package:paint/result.dart';
import 'package:paint/setting.dart';
import 'package:paint/shared_prefference_app.dart';
import 'package:paint/troubleshoot.dart';
import 'package:paint/video_gallery.dart';
import 'package:paint/weather.dart';
import 'package:paint/web_view_global.dart';
import 'package:shake/shake.dart';
import 'package:share/share.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';
import 'NearBy/get_near_by.dart';
import 'StudentLogin/student_dashboard_weview.dart';
import 'about_university.dart';
import 'constant.dart';
import 'developer.dart';
import 'favorite_notice.dart';
import 'notifications.dart';
import 'Map/map.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<FlipCardState> _cardKey = GlobalKey<FlipCardState>();
  SharedPrefData spa = SharedPrefData();
  final FetchFrom _fetchFrom = FetchFrom(url: 'images.php');
  late List<dynamic> images = ['${_fetchFrom.baseurl}/img/1.gif'];
  late var link = {'${_fetchFrom.baseurl}/img/1.gif': '0'};
  late int lengthImg = 1;
  int activeImgIndex = 1;
  bool localImage = true;
  String name = 'Guest';

  @override
  void initState() {
    // TODO: implement initState
    settings();
    super.initState();
    makeImageList();
    myBanner.load();

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      //print(event.toString());
    });

    ShakeDetector detector = ShakeDetector.autoStart(onPhoneShake: () {
      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Working"),));
      Navigator.push(
          context,
          PageTransition(
              childCurrent: widget,
              child: StudentLoginWebview(
                  'https://studentservice.iust.ac.in/Services/Default.aspx'),
              type: PageTransitionType.leftToRight));
    });
  }

  settings() async {
    await Future.delayed(const Duration(seconds: 2), () {
      OnInstall();
    });
    name = (await spa.getProfileName())!;
  }

  void makeImageList() async {
    var data = jsonDecode(await _fetchFrom.GetData());
    _fetchFrom.GetData().then((value) {
      localImage = false;
      List<dynamic> data = jsonDecode(value.toString())['data'];
      lengthImg = data.length + 1;
      data.forEach((i) {
        images.add(Constant.univerUrl + i['img']);
        if (i['link'] == null) {
          link.addAll({Constant.univerUrl + i['img']: '0'});
        } else {
          link.addAll({Constant.univerUrl + i['img']: i['link']});
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var fullScreenHeight = MediaQuery
        .of(context)
        .size
        .height;
    var statusBarHeight = MediaQuery
        .of(context)
        .padding
        .top;
    var totalHeight = fullScreenHeight - statusBarHeight;
    return UpgradeAlert(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            toolbarHeight: 30,
            iconTheme: IconThemeData(color: Colors.red.shade400, size: 30),
            actions: [
              PopupMenuButton(
                  itemBuilder: (context){
                    return [
                      const PopupMenuItem<int>(
                        value: 0,
                        child: Text("Notification Settings"),
                      ),
                    ];
                  },
                  onSelected:(value){
                    if(value == 0){
                      Navigator.push(
                          context,
                          PageTransition(
                              child: const Setting(),
                              type: PageTransitionType.topToBottom));
                    }
                  }
              ),
            ],
          ),
          drawer: Drawer(
            elevation: 0.0,
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 10.0, right: 0.0),
              children: [
                UserAccountsDrawerHeader(
                  margin: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: Constant.primaryColor,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(
                          0.0,
                          0.0,
                        ),
                        blurRadius: 0.9,
                        spreadRadius: 0.9,
                      ),
                    ],
                  ),
                  accountName: Text(
                    "Welcome :" + name,
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: GoogleFonts.kanit(),
                  ),
                  accountEmail: null,
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: const Color(0xffF0CF56),
                    child: Text(
                      name.substring(0, 1),
                      style: const TextStyle(fontSize: 40.0),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.directions,
                    color: Constant.primaryColor,
                  ),
                  title: Text(
                    "Project Guide",
                    style: GoogleFonts.kanit(),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            child: const Developer(),
                            type: PageTransitionType.topToBottom));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.developer_board,
                    color: Constant.primaryColor,
                  ),
                  title: Text(
                    "Developers",
                    style: GoogleFonts.kanit(),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            child: const Developer(),
                            type: PageTransitionType.topToBottom));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.account_balance_outlined,
                    color: Constant.primaryColor,
                  ),
                  title: Text(
                    "About University",
                    style: GoogleFonts.kanit(),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            child: const AboutUniversity(),
                            type: PageTransitionType.topToBottom));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.share,
                    color: Constant.primaryColor,
                  ),
                  title: Text(
                    "Share",
                    style: GoogleFonts.kanit(),
                  ),
                  onTap: () async {
                    await Share.share(
                        "Click to Download IUST APP. \n https://play.google.com/store/apps/details?id=com.bhatakeed.iust",
                        subject: "Download IUST APP.");
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.web,
                    color: Constant.primaryColor,
                  ),
                  title: Text(
                    "Website",
                    style: GoogleFonts.kanit(),
                  ),
                  onTap: () async {
                    await launchUrl(Uri.parse("https://iust.ac.in"));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.policy,
                    color: Constant.primaryColor,
                  ),
                  title: Text(
                    "Privacy & Policy",
                    style: GoogleFonts.kanit(),
                  ),
                  onTap: () async {
                    Navigator.push(
                        context,
                        PageTransition(
                            child: WebViewGlobal(
                                title: "Privacy & Policy",
                                url: "https://bhatakeed.in/pp.php"),
                            type: PageTransitionType.topToBottom));
                  },
                ),
                Divider(
                  color: Constant.primaryColor,
                  height: 0.2,
                ),
                ListTile(
                  leading: Icon(
                    Icons.arrow_back,
                    color: Constant.primaryColor,
                  ),
                  title: Text(
                    "Close",
                    style: GoogleFonts.kanit(),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          //bottomNavigationBar:  SizedBox(height: 59, child: Card(child: AdWidget(ad: myBanner))),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(
                          0.0,
                          0.0,
                        ),
                        blurRadius: 0.9,
                        spreadRadius: 0.9,
                      ),
                    ],
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                  ),
                  child: imageSlide()),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: buildIndecator(),
              ),
              Expanded(
                //height: totalHeight - 161,
                flex: 1,
                child: ListView(
                    padding:
                    const EdgeInsets.only(top: 0.0, left: 3.0, right: 3.0),
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 5, bottom: 9.0),
                        width: double.infinity,
                        alignment: Alignment.topCenter,
                        margin: const EdgeInsets.only(top: 2),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(
                                0.0,
                                0.0,
                              ),
                              blurRadius: 0.9,
                              spreadRadius: 0.9,
                            ),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  child: _buildIconTextMenu(
                                      'Student Login', 'login2.png'),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: StudentLoginWebview(
                                                'https://studentservice.iust.ac.in/Services/Default.aspx'),
                                            type: PageTransitionType
                                                .topToBottom));
                                  },
                                ),
                                GestureDetector(
                                  child:
                                  _buildIconTextMenu('Result', 'result2.png'),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: const Result(),
                                            type: PageTransitionType
                                                .topToBottom));
                                  },
                                ),
                                GestureDetector(
                                  child: _buildIconTextMenu(
                                      'Notifications', 'notification2.gif'),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: const Notifications(),
                                            type: PageTransitionType
                                                .topToBottom));
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  child:
                                  _buildIconTextMenu('Nearby', 'nearby2.png'),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: const GetNearBy(),
                                            type: PageTransitionType
                                                .topToBottom));
                                  },
                                ),
                                GestureDetector(
                                  child:
                                  _buildIconTextMenu('Campus Map', 'map2.png'),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: const Map(),
                                            type: PageTransitionType
                                                .topToBottom));
                                  },
                                ),
                                GestureDetector(
                                  child: _buildIconTextMenu(
                                      'Favorites', 'favourite5.png'),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: const FavoriteNotice(),
                                            type: PageTransitionType
                                                .topToBottom));
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  child: _buildIconTextMenu(
                                      'Video Gallery', 'video-playlist2.png'),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: const VideoGalley(),
                                            type: PageTransitionType
                                                .topToBottom));
                                  },
                                ),
                                GestureDetector(
                                  child: _buildIconTextMenu(
                                      'Downloads', 'downloads2.png'),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: const Downloads(),
                                            type: PageTransitionType
                                                .topToBottom));
                                  },
                                ),
                                GestureDetector(
                                  child:
                                  _buildIconTextMenu('Syllabus', 'book.png'),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: SDepartmentList(
                                              nextPage: 'get',
                                              ptitle: 'Syllabus',),
                                            type: PageTransitionType
                                                .topToBottom));
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  child: _buildIconTextMenu(
                                      'Help', 'help2.png'),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: const Troubleshoot(),
                                            type: PageTransitionType
                                                .topToBottom));
                                  },
                                ),
                                GestureDetector(
                                  child: _buildIconTextMenu(
                                      'Ask Me', 'qa.png'),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: const Chat(),
                                            type: PageTransitionType
                                                .topToBottom));
                                  },
                                ),
                                GestureDetector(
                                  child:
                                  _buildIconTextMenu('Study Material', 'studyMaterial.png'),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: StudyMaterial(nextPage: "get", ptitle: "Study Material"),
                                            type: PageTransitionType
                                                .topToBottom));
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      _buildFlipBox(),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(left: 15),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            gradient: RadialGradient(radius: 10, colors: [
                              Colors.lightBlueAccent.withOpacity(0.5),
                              Colors.white,
                            ])),
                        child: Row(
                            children: [
                              const Icon(Icons.circle_rounded),
                              const SizedBox(width: 10,),
                              Text(
                                "Story",
                                style: GoogleFonts.kanit(
                                    fontWeight: FontWeight.w400),
                              ),
                            ]
                        ),
                      ),
                      const Storey(),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(left: 15),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            gradient: RadialGradient(radius: 10, colors: [
                              Colors.lightBlueAccent.withOpacity(0.5),
                              Colors.white,
                            ])),
                        child: Row(
                            children: [
                              const Icon(Icons.event_note),
                              const SizedBox(width: 10,),
                              Text(
                                "Upcoming / Held Events",
                                style: GoogleFonts.kanit(
                                    fontWeight: FontWeight.w400),
                              ),
                            ]
                        ),
                      ),
                      const IustEvents(),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildIndecator() {
    return Container(
      alignment: Alignment.center,
      child: AnimatedSmoothIndicator(
        activeIndex: activeImgIndex,
        count: lengthImg,
        effect: const ExpandingDotsEffect(
          dotColor: Color(0xff69CCFA),
          dotWidth: 40,
          dotHeight: 3,
          activeDotColor: Colors.black,
        ),
      ),
    );
  }

  Widget _buildFlipBox() {
    return Container(
        height: 180,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(
                0.0,
                0.0,
              ),
              blurRadius: 0.9,
              spreadRadius: 0.9,
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: FlipCard(
            key: _cardKey,
            front: Stack(children: [
              const FirstCardFlip(),
              Container(
                width: 100,
                height: 30,
                alignment: Alignment.bottomRight,
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                      radius: 10,
                      colors: [Colors.black.withOpacity(0.3), Colors.white]),
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
                child: Center(
                  child: TextButton(
                    onPressed: () => _cardKey.currentState!.toggleCard(),
                    child: Text(
                      "Get Weather",
                      style: GoogleFonts.abel(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ]),
            back: const WeatherGet()));
  }

  _buildIconTextMenu(String title, String img) {
    return SizedBox(
      width: 85,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            child: Image.asset(
              'assets/images/main/$img',
              width: 50,
              height: 42,
              scale: 1,
            ),
          ),
          Center(
            child: FittedBox(
              child: Text(
                title,
                style: GoogleFonts.kanit(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget imageSlide() {
    return CarouselSlider(
        items: images.map((e) {
          return Builder(
            builder: (BuildContext context) {
              return Stack(children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 1, right: 1),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    image: DecorationImage(
                      image: localImage == true
                          ? const AssetImage('assets/images/head.gif')
                          : CachedNetworkImageProvider(
                        e,
                      ) as ImageProvider,
                      fit: BoxFit.fill,
                      filterQuality: FilterQuality.low,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                link[e].toString() != '0'
                    ? GestureDetector(
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 100),
                      width: 150,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius:
                        const BorderRadius.all(Radius.circular(10)),
                        gradient: RadialGradient(radius: 3, colors: [
                          Colors.lightBlueAccent.withOpacity(0.5),
                          Colors.white,
                        ]),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: const Offset(
                                2, 2), // changes position of shadow
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          "Read More",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            child: WebViewGlobal(
                                title: "Read More", url: link[e].toString()),
                            type: PageTransitionType.topToBottom));
                  },
                )
                    : const SizedBox(),
              ]);
            },
          );
        }).toList(),
        options: CarouselOptions(
            viewportFraction: 0.99,
            autoPlay: true,
            height: 150,
            initialPage: 0,
            onPageChanged: (pno, _) {
              setState(() {
                activeImgIndex = pno;
              });
            }));
  }

  final BannerAd myBanner = BannerAd(
    adUnitId: 'ca-app-pub-2790734698265499/4875692009',
    size: AdSize.banner,
    request: const AdRequest(),
    listener: const BannerAdListener(),
  );
}
