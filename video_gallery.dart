import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paint/constant.dart';
import 'package:paint/internet_check.dart';
import 'package:paint/youtube_player.dart';
import 'package:http/http.dart' as http;
class VideoGalley extends StatefulWidget {
  const VideoGalley({Key? key}) : super(key: key);

  @override
  _VideoGalleyState createState() => _VideoGalleyState();
}

class _VideoGalleyState extends State<VideoGalley> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  dynamic getVideos() async {
    String baseurl = "https://bhatakeed.in/iust/iust/video.php";
    var response = await http.get(Uri.parse(baseurl));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return 'e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Gallery'),
        flexibleSpace: Constant.KFlexibleSpaceBar,
      ),
      body: FutureBuilder(
        future: getVideos(),
        builder: (context,snapshot) {
            if (snapshot.hasData) {
               dynamic data = jsonDecode(snapshot.data.toString())['data'];
                return  Container(
                  color: Constant.KbodyColor,
                  child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context,int i){
                          return Card(
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Center(child: Text(data[i]['text'].toString(),),),
                                  Container(child: null,height: 1,color: Constant.primaryColor,),
                                  const SizedBox(height: 2,),
                                  YoutubePlayerApp(videoPlayerId: data[i]['id'].toString()),
                                ],
                              ),
                            ),
                          );
                        }),
                );
            } else {
              return const Center(child: CircularProgressIndicator(),);
            }
        }
      ),
    );
  }
}
