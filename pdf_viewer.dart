import 'dart:io';
import 'package:dio/dio.dart';
import 'package:just_audio/just_audio.dart';
import 'package:paint/constant.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:open_file_safe/open_file_safe.dart';

class PdfViewer extends StatefulWidget {
  final String url;
  final String title;
  const PdfViewer(this.url,this.title,{Key? key}) : super(key: key);

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  int index = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,
          style: const TextStyle(fontFamily: 'Dosis', fontWeight: FontWeight.bold),),
          flexibleSpace: Constant.KFlexibleSpaceBar,
      ),
      body: SafeArea(
        child: SfPdfViewer.network(
          widget.url,
          key: _pdfViewerKey,
        ),),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.white,
        backgroundColor: Colors.blue,
        unselectedItemColor: Colors.white,
        elevation: 7,
        currentIndex: index,
        onTap: (int index) async {
          setState(() {
            this.index = index;
          });
          if(index == 0){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Downloading..."),duration: Duration(seconds: 3),));
            download(widget.url);
          }else{
            await Share.share(widget.title+" \n "+widget.url+" \n\n\n Shared Via IUST App. https://play.google.com/store/apps/details?id=com.bhatakeed.iust", subject: widget.title);
          }
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.download),
            label: "Download",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.share),
            label: "Share"
          ),
        ],
      ),
    );
  }
}

download(String link) async {

    try {
      var response = await Dio().get(link,options: Options(responseType: ResponseType.bytes));
      var fname = link.split("/");
      final file = File("/storage/emulated/0/IUST/"+fname[fname.length-1]);
      RandomAccessFile raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      raf.close();
      final player = AudioPlayer();
      var duration = await player.setAsset('assets/sounds/download.mp3');
      player.play();

      OpenFile.open(file.path);
    } catch (e) {
      //print(e);
    }

}