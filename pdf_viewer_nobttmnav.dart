import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:paint/constant.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter/material.dart';

class PdfViewerNoBttNav extends StatefulWidget {
  final String url;
  final String title;
  const PdfViewerNoBttNav(this.url,this.title,{Key? key}) : super(key: key);

  @override
  State<PdfViewerNoBttNav> createState() => _PdfViewerNoBttNavState();
}

class _PdfViewerNoBttNavState extends State<PdfViewerNoBttNav> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  int index = 0;

  @override
  void initState() {
    // TODO: implement initState
    disableCapture();
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
    enableCapture();
  }

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
    );
  }

  Future<void> disableCapture() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  Future<void> enableCapture() async {
    await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
  }
}
