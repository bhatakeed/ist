import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:paint/DBhelper/db_helper.dart';
import 'package:paint/constant.dart';
import 'package:paint/list_notice.dart';

class FavoriteNotice extends StatefulWidget {
  const FavoriteNotice({Key? key}) : super(key: key);

  @override
  _FavoriteNoticeState createState() => _FavoriteNoticeState();
}

class _FavoriteNoticeState extends State<FavoriteNotice> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Favorite List",
            style: TextStyle(fontFamily: 'Dosis', fontWeight: FontWeight.bold),),
          flexibleSpace: Constant.KFlexibleSpaceBar,
        ),
        body: FutureBuilder(
          future: DBhelper.getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                if(snapshot.data.toString().length>3) {
                   return ListNotice(jsonEncode({'data': snapshot.data}));
                }else{
                  return const Center(
                    child: Text("No item in Favorite List",style: Constant.KTitleStyle,),
                  );
                }
              }else{
                return const Center(
                  child: Text("No item in Favorite List",style: Constant.KTitleStyle,),
                );
              }
            } else {
              return const Center(child: CircularProgressIndicator(),);
            }
          },
        ),
      ),
    );
  }
}
