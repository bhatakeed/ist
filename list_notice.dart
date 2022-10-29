import 'dart:convert';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paint/DBhelper/db_helper.dart';
import 'package:paint/constant.dart';
import 'package:paint/internet_check.dart';
import 'package:paint/pdf_viewer.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class ListNotice extends StatefulWidget {
  dynamic rdata, data;

  ListNotice(rdata, {Key? key}) : super(key: key) {
    data = jsonDecode(rdata)['data'];
  }

  @override
  State<ListNotice> createState() => _ListNoticeState();
}

class _ListNoticeState extends State<ListNotice> {
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
                                        FutureBuilder(
                                            future: DBhelper.selectByid(
                                                id: int.parse(widget.data[i]['id'])),
                                            builder:
                                                (BuildContext context, sp) {
                                              if (sp.connectionState ==
                                                  ConnectionState.done) {
                                                return StarButton(
                                                    isStarred: sp.hasData,
                                                    iconSize: 35,
                                                    iconColor: Colors.red,
                                                    valueChanged: (value) async {
                                                      if(value==true){
                                                        await DBhelper.insert({'id': widget.data[i]['id'],'title':widget.data[i]['title'],'url':widget.data[i]['url'],'date':widget.data[i]['date'],'new':0,'link':widget.data[i]['link']});
                                                      }else{
                                                        await DBhelper.deleteData(id: widget.data[i]['id'].toString());
                                                      }
                                                    });
                                              }
                                              return const SizedBox();
                                            }),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          widget.data[i]['date'].toString(),
                                          style: GoogleFonts.abel(fontSize: 10),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 5.0),
                                          child: FutureBuilder(
                                              future: DBhelper.seen(
                                                  id: int.parse(widget.data[i]['id'])),
                                              builder:
                                                  (BuildContext context, sp) {
                                                if (sp.connectionState ==
                                                    ConnectionState.done) {
                                                  return sp.hasData==true?const Icon(Icons.remove_red_eye_outlined,size: 15,color: Colors.lightBlueAccent,):const SizedBox();
                                                }
                                                return const SizedBox();
                                              }),
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
                      Visibility(
                        visible: int.parse(widget.data[i]['new']) == 1,
                        child: Container(
                          padding: EdgeInsets.only(left: 5),
                          width: 50,
                          child: Image.asset('assets/images/new.png'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () async {
                await DBhelper.insertSeen({'id':widget.data[i]['id']});
                int.parse(widget.data[i]['link']) != 1
                    ? Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PdfViewer(
                          widget.data[i]['url'],
                          widget.data[i]['title'])),
                )
                    : showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (context) {
                      return FractionallySizedBox(
                          heightFactor: 0.4,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Column(
                                children: [
                                  Card(
                                    elevation: 0.5,
                                    color: Colors.blue.shade50,
                                    child: Padding(
                                      padding: const     EdgeInsets.all(0.5),
                                      child: Text(
                                        widget.data[i]['title'],
                                        textAlign: TextAlign.center,
                                        style: Constant.KTitleStyle,
                                      ),
                                    ),
                                  ),
                                  Expanded(flex: 1, child: SizedBox()),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: [
                                      GestureDetector(
                                        child: Column(
                                          children: const [
                                            Icon(
                                              Icons.open_in_browser,
                                              color: Colors.blue,
                                            ),
                                            Text(
                                              "Open in Browser",
                                              style: TextStyle(
                                                  fontFamily: 'Dosis',
                                                  color: Colors.blue,
                                                  fontWeight:
                                                  FontWeight.bold),
                                            )
                                          ],
                                        ),
                                        onTap: () async {
                                          await launch('' +
                                              widget.data[i]['url'] +
                                              '');
                                        },
                                      ),
                                      GestureDetector(
                                        child: Column(
                                          children: const [
                                            Icon(
                                              Icons.share,
                                              color: Colors.blue,
                                            ),
                                            Text(
                                              "Share",
                                              style: TextStyle(
                                                  fontFamily: 'Dosis',
                                                  color: Colors.blue,
                                                  fontWeight:
                                                  FontWeight.bold),
                                            )
                                          ],
                                        ),
                                        onTap: () async {
                                          await Share.share(
                                              widget.data[i]['title'] +
                                                  " \n " +
                                                  widget.data[i]['url'] +
                                                  " \n Shared Via IUST App. https://play.google.com/store/apps/details?id=com.bhatakeed.iust",
                                              subject: widget.data[i]
                                              ['title']);
                                        },
                                      ),
                                    ],
                                  ),
                                  const Expanded(
                                      flex: 1, child: SizedBox()),
                                ],
                              ),
                            ),
                          ));
                    });
              },
            );
          }),
      const InertnetCheck(),
    ]);
  }
}
