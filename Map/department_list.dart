import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:paint/Map/view_map.dart';
import 'package:paint/internet_check.dart';

// ignore: must_be_immutable
class DepartmentList extends StatefulWidget {
  dynamic rdata, data;

  DepartmentList(rdata, {Key? key}) : super(key: key) {
    data = jsonDecode(rdata)['data'];
  }

  @override
  State<DepartmentList> createState() => _DepartmentListState();
}

class _DepartmentListState extends State<DepartmentList> {

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
  Widget build(BuildContext context) {
    return Stack(children: [
      ListView.builder(
          itemCount: widget.data.length,
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
                                            widget.data[i]['title'].toString(),
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
                                          widget.data[i]['Desc'].toString(),
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
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewMap(widget.data[i])),
                );
              },
            );
          }),
      const InertnetCheck(),
    ]);
  }
}
