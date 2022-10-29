import 'package:flutter/material.dart';
import 'package:paint/Map/department_list.dart';
import 'package:paint/fetch_from.dart';
import 'package:paint/internet_connection.dart';
import 'package:paint/list_notice.dart';

// ignore: must_be_immutable
class MapList extends StatefulWidget {
  MapList({Key? key}) : super(key: key);

  @override
  State<MapList> createState() => _MapListState();
}

class _MapListState extends State<MapList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  dynamic getData() async {
    FetchFrom get = FetchFrom(url: "map.php");
    return get.GetData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot){
        if(snapshot.hasData){
          return DepartmentList(snapshot.data);
        }else{
          return const InternetConnection();
        }
      },
    );
  }
}
