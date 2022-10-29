import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paint/fetch_from.dart';
import 'package:paint/youtube_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FirstCardFlip extends StatefulWidget {
  const FirstCardFlip({Key? key}) : super(key: key);

  @override
  State<FirstCardFlip> createState() => _FirstCardFlipState();
}

class _FirstCardFlipState extends State<FirstCardFlip> {
  late int isVideo;
  late String link;
  late bool autoplay;
  late bool mute;
  late bool isLive;
  late bool hideControl;

  @override
  void initState() {
    super.initState();
  }

  Future<String> _getData() async {
    FetchFrom fetchfrom = FetchFrom(url: 'imageVideo.php');
    var data = jsonDecode(await fetchfrom.GetData())['data'];
    isVideo = data['isVideo'];
    link = data['link'];
    autoplay = data['autoplay'];
    mute = data['mute'];
    isLive = data['islive'];
    hideControl = data['hidecontrol'];
    return link;
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Card(
              elevation: 1,
              child: Container(
                padding: const EdgeInsets.all(1.0),
                child: isVideo == 1
                    ? YoutubePlayer(
                        controller:  YoutubePlayerController(
                          initialVideoId: YoutubePlayer.convertUrlToId(link)!,
                          flags: YoutubePlayerFlags(
                            autoPlay: autoplay,
                            hideControls: hideControl,
                            mute: mute,
                            isLive: isLive
                          ),
                        ),
                        showVideoProgressIndicator: true,
                        width: double.infinity,
                      )
                    : Container(
                        decoration: BoxDecoration(
                            color: Colors.lightBlueAccent,
                            image: DecorationImage(
                                fit: BoxFit.fill, image: NetworkImage(link))),
                      ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
