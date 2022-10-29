import 'package:flutter/material.dart';
import 'package:paint/fetch_from.dart';
import 'package:paint/list_notice.dart';

import 'internet_connection.dart';

class RecrumentNotice extends StatefulWidget {
  const RecrumentNotice({Key? key}) : super(key: key);

  @override
  _RecrumentNoticeState createState() => _RecrumentNoticeState();
}

class _RecrumentNoticeState extends State<RecrumentNotice> {
  getData() {
    FetchFrom get = FetchFrom(url: "fetch.php?id=JOB");
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
