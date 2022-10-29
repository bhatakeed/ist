import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paint/constant.dart';
import 'package:paint/fetch_from.dart';
import 'package:paint/internet_check.dart';
import 'package:paint/pdf_viewer_nobttmnav.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

// ignore: must_be_immutable
class StudyMaterial extends StatefulWidget {
  String nextPage;
  String ptitle;

  StudyMaterial({required this.nextPage,required this.ptitle,Key? key}) : super(key: key);
  @override
  State<StudyMaterial> createState() => _StudyMaterialState();
}

class _StudyMaterialState extends State<StudyMaterial> {
 late dynamic data;
 late dynamic globalData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _rewardedAd();
    fetchData();
  }



 void _rewardedAd(){
    RewardedAd.load(adUnitId: 'ca-app-pub-2790734698265499/4947747063', request: const AdRequest(
      nonPersonalizedAds: false,
    ),rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (RewardedAd ad){
      ad.show(onUserEarnedReward: (wa,ri){
      });
    }, onAdFailedToLoad: (LoadAdError error){
      _rewardedAd();
   }));
 }


  fetchData() async {
    FetchFrom get = FetchFrom(url: "studyMaterial.php?np=${widget.nextPage}");
    globalData = jsonDecode(await get.GetData());
    return data = globalData['data'];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.ptitle),
          flexibleSpace: Constant.KFlexibleSpaceBar,
        ),
        body: FutureBuilder(
          future: fetchData(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if(snapshot.hasData){
              return Stack(children: [
                Container(
                  color: Constant.KbodyColor,
                  child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int i) {
                        return GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Card(
                              shadowColor: Colors.blue,
                              child: Stack(
                                children: [
                                  IntrinsicHeight(
                                    child: Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(top: 1.0, bottom: 0),
                                      height: double.infinity,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15, left: 10, bottom: 10),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        data[i]['title'].toString(),
                                                        style: GoogleFonts.kanit(),
                                                        textAlign: TextAlign.justify,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      data[i]['email'].toString(),
                                                      style: GoogleFonts.abel(fontSize: 10),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            if(globalData['npage']==true){
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: StudyMaterial(nextPage: data[i]['id'],ptitle: data[i]['title']),
                                      type: PageTransitionType.topToBottom));
                            }else{
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: PdfViewerNoBttNav(data[i]['url'],data[i]['title']),
                                      type: PageTransitionType.topToBottom));
                            }
                          },
                        );
                      }),
                ),
                const InertnetCheck(),
              ]);
            }else{
              return const Center(child: CircularProgressIndicator(),);
            }
          },
        ),
      );
  }


 alertMessage(String message){
   Alert(
     context: context,
     type: AlertType.error,
     title: "Oops!!",
     desc: message,
     buttons: [
       DialogButton(
         child: const Text(
           "Go Back",
           style: TextStyle(color: Colors.white, fontSize: 20),
         ),
         onPressed: () => Navigator.pop(context),
         width: 120,
       )
     ],
   ).show();
 }
}
