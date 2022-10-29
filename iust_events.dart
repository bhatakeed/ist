import 'dart:convert';
import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paint/fetch_from.dart';
import 'package:paint/pdf_viewer.dart';
import 'DBhelper/db_helper.dart';

class IustEvents extends StatefulWidget {
  const IustEvents({Key? key}) : super(key: key);

  @override
  State<IustEvents> createState() => _IustEventsState();
}

class _IustEventsState extends State<IustEvents> {
  late List<Widget> events=[];
  @override
  void initState() {
    // TODO: implement initState
    fetchEvents();
    super.initState();
  }

  Future<void> fetchEvents() async {
    FetchFrom fetchFrom = FetchFrom(url: 'events.php');
    var events=jsonDecode(await fetchFrom.GetData())['data'];
    await DBhelper.deleteEvents();
    events.forEach((dynamic data) async {
      await DBhelper.insertEvents(data);
    });
    setState((){});
  }

  Future<int> getEvents() async {
    await DBhelper.getEvents().then((value){
      value.forEach((element) {
        events.add(GestureDetector(
          child: SizedBox(
            width: double.infinity,
            height: 100,
            child: Card(
              elevation: 2,
              child: Column(
                children: [
                  Container(
                    height: 5,
                    decoration: const BoxDecoration(
                        borderRadius:
                        BorderRadius.all(Radius.circular(2.0)),
                        gradient: LinearGradient(colors: [
                          Color(0xff3786AD),
                          Color(0xff6ACAFA)
                        ])),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(10.0),
                      gradient: const LinearGradient(colors: [
                        Color(0xffFA828E),
                        Color(0xffFAF450)
                      ]),
                    ),
                    child: Center(
                      child: Text(
                        element['date'],
                        style: GoogleFonts.alegreya(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(10.7)),
                      gradient: LinearGradient(colors: [
                        Colors.lightBlueAccent.withOpacity(0.4),
                        Colors.white
                      ]),
                    ),
                    child: Center(
                      child: Text(
                        element['title'],
                        style: GoogleFonts.kanit(fontSize: 13,color: Colors.black),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          onTap: (){
            element['link']!=null?Navigator.push(
                context,
                PageTransition(
                    child: PdfViewer(element['link'], element['title']),
                    type: PageTransitionType.topToBottom)):ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Details not Available")));
          },
        ),
        );
      });
    });
    setState((){});
    return 1;
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getEvents(),
        builder: (context,snapshot){
        if(snapshot.hasData){
          return CarouselSlider(
              options: CarouselOptions(
                  height: 100.0,
                  autoPlay: true,
                  scrollDirection: Axis.horizontal,
                  enlargeCenterPage: false,
                  autoPlayCurve: Curves.bounceOut),
              items: events);
        }else{
          return const Center(child: CircularProgressIndicator());
        }
    });
  }
}
