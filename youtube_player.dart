import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerApp extends StatefulWidget {
  String videoPlayerId;
  YoutubePlayerApp({Key? key, required this.videoPlayerId}) : super(key: key);

  @override
  _YoutubePlayerAppState createState() => _YoutubePlayerAppState();
}

class _YoutubePlayerAppState extends State<YoutubePlayerApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }



  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: YoutubePlayerController(
        initialVideoId: widget.videoPlayerId, //Add videoID.
        flags: const YoutubePlayerFlags(
          hideControls: false,
          controlsVisibleAtStart: true,
          autoPlay: false,
          mute: false,
        ),
      ),
      showVideoProgressIndicator: true,
      //progressIndicatorColor: AppColors.primary,
    );
  }
}
