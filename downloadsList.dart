import 'package:flutter/material.dart';
import 'package:paint/fetch_from.dart';
import 'package:paint/internet_connection.dart';
import 'package:paint/list_notice.dart';

// ignore: must_be_immutable
class DownloadsList extends StatefulWidget {
  late String tab;
  DownloadsList({Key? key, required this.tab}) : super(key: key);

  @override
  State<DownloadsList> createState() => _DownloadsListState();
}

class _DownloadsListState extends State<DownloadsList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  dynamic getData() async {
    FetchFrom get = FetchFrom(url: "downloads.php?tab=${widget.tab}");
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
