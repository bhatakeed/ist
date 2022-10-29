import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:paint/admission_notice.dart';
import 'package:paint/constant.dart';
import 'package:paint/examination_notice.dart';
import 'package:paint/general_notice.dart';
import 'package:paint/recruitment_notice.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createInterstitialAd();
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
  @override
  void dispose() {

  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 4,
      child: Scaffold(
          //bottomNavigationBar:
          //SizedBox(height: 50, child: AdWidget(ad: myBanner)),
          appBar: AppBar(
            flexibleSpace: Constant.KFlexibleSpaceBar,
            title: FittedBox(
                child: Text(
                  "Notifications, Announcement & Recruitments",
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
            decoration: BoxDecoration(
                color: Constant.KbodyColor,
                borderRadius: const BorderRadius.only(
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
          ),
      ),
    );
  }
}
