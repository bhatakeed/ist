import 'package:flutter/material.dart';
import 'package:paint/fetch_from.dart';

import 'internet_connection.dart';
import 'list_notice.dart';

class AdmissionNotice extends StatefulWidget {
  const AdmissionNotice({Key? key}) : super(key: key);

  @override
  _AdmissionNoticeState createState() => _AdmissionNoticeState();
}

class _AdmissionNoticeState extends State<AdmissionNotice> {
  getData() {
    FetchFrom get = FetchFrom(url: "fetch.php?id=ADM");
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
