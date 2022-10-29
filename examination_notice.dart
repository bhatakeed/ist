import 'package:flutter/material.dart';
import 'package:paint/fetch_from.dart';
import 'package:paint/internet_connection.dart';
import 'package:paint/list_notice.dart';

class ExaminationNotice extends StatefulWidget {
  const ExaminationNotice({Key? key}) : super(key: key);

  @override
  _ExaminationNoticeState createState() => _ExaminationNoticeState();
}

class _ExaminationNoticeState extends State<ExaminationNotice> {
  getData() {
    FetchFrom get = FetchFrom(url: "fetch.php?id=EXM");
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
