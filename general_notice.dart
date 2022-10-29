import 'package:flutter/material.dart';
import 'package:paint/fetch_from.dart';
import 'package:paint/internet_connection.dart';
import 'package:paint/list_notice.dart';

class GeneralNotice extends StatefulWidget {
  const GeneralNotice({Key? key}) : super(key: key);

  @override
  State<GeneralNotice> createState() => _GeneralNoticeState();
}

class _GeneralNoticeState extends State<GeneralNotice> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  dynamic getData() async {
    FetchFrom get = FetchFrom(url: "fetch.php?GEN=1");
    return get.GetData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot){
        if(snapshot.hasData){
          return ListNotice(snapshot.data);
        }else{
          return const InternetConnection();
        }
      },
    );
  }
}
