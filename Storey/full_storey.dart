import 'dart:async';
import "package:story_view/story_view.dart";
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FullStorey extends StatefulWidget {
  dynamic data;

  FullStorey({Key? key, required this.data}) : super(key: key);

  @override
  State<FullStorey> createState() => _FullStoreyState();
}

class _FullStoreyState extends State<FullStorey> {
  StoryController storyController = StoryController();
  List<StoryItem> dataz=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    story();
  }

  void story(){
    widget.data.forEach((value){
      dataz.add(StoryItem.pageImage(url: value['link'],caption: value['title'], controller: storyController));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoryView(storyItems: dataz, controller: storyController,),
    );
  }
}
