import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:paint/Map/full_map.dart';
import 'package:paint/Map/map_list.dart';
import 'package:paint/constant.dart';

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {

  @override
  void initState() {
    // TODO: implement initState
    //_speak("test");
    //OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    //OnInstall();
    super.initState();
    _createInterstitialAd();
    myBanner.load();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-2790734698265499/3564066912',
      request: const AdRequest(),
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
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        //bottomNavigationBar:
        //SizedBox(height: 50, child: AdWidget(ad: myBanner)),
        appBar: AppBar(
          flexibleSpace: Constant.KFlexibleSpaceBar,
          title: FittedBox(
              child: Text(
                "Campus Map",
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
                        "Departments",
                        style: Constant.tabsTextStyle.copyWith(fontSize: 12),
                      )),
                  FittedBox(
                      child: Text(
                        "Full Map",
                        style: Constant.tabsTextStyle,
                      )),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.only(top: 6),
          decoration: BoxDecoration(
              color: Constant.KbodyColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20))),
          child: TabBarView(
            children: [
              MapList(),
              FullMap(),
            ],
          ),
        ),
      ),
    );
  }
}
