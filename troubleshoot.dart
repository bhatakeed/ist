import 'package:flutter/material.dart';
import 'package:paint/constant.dart';
import 'package:paint/youtube_player.dart';

class Troubleshoot extends StatelessWidget {
  const Troubleshoot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          flexibleSpace: Constant.KFlexibleSpaceBar,
          title: const Text("Troubleshoot"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              children: [
                Expanded(
                  flex: 0,
                  child: Card(
                    elevation: 2.0,
                    shadowColor: Constant.primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 5,),
                          FractionallySizedBox(child: YoutubePlayerApp(videoPlayerId: 'y1keMgBib-Y')),
                          const SizedBox(height: 5,),
                          Container(child: null,height: 1,color: Constant.primaryColor,),
                          const SizedBox(height: 5,),
                          const Text("Users with Android, especially Huawei,Honor & Redmi phones may face the problem of not receiving notifications (on time). It’s a common problem because of  Battery optimization settings.\n\nFollow these steps to fix this problem.",style: Constant.KTitleStyle,textAlign: TextAlign.justify,),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
