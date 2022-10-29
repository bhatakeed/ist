import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:paint/DBhelper/db_helper.dart';
import 'package:paint/Storey/full_storey.dart';
import 'package:paint/fetch_from.dart';

class Storey extends StatefulWidget {
  const Storey({Key? key}) : super(key: key);

  @override
  State<Storey> createState() => _StoreyState();
}

class _StoreyState extends State<Storey> {
  FetchFrom ff = FetchFrom(url: 'storey.php');
  List<String> clr=['0'];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStorey();
    //DBhelper.deleteStory();
  }

  Future<dynamic> getStorey() async {
    return jsonDecode(await ff.GetData())['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      child: SizedBox(
        height: 70,
        width: double.infinity,
        child: FutureBuilder(
            future: getStorey(),
            builder: (BuildContext context,AsyncSnapshot snapshot){
               if(snapshot.hasData){
                 return Center(
                   child: ListView.builder(
                         shrinkWrap: true,
                         scrollDirection: Axis.horizontal,
                         itemCount: snapshot.data!.length,
                         itemBuilder: (BuildContext context,int id){
                           DBhelper.storySlectByid(id:snapshot.data[id][0]['id']).then((value){
                               setState(() {
                                 clr.add(value);
                               });
                           });
                           return GestureDetector(
                             child: Container(
                               height: 60,
                               width: 60,
                               decoration: BoxDecoration(
                                 shape: BoxShape.circle,
                                 gradient: RadialGradient(
                                     colors: [
                                       // ignore: unnecessary_null_comparison
                                       !clr.contains(snapshot.data[id][0]['id'])?Colors.red:Colors.white,
                                       !clr.contains(snapshot.data[id][0]['id'])?Colors.red:Colors.white,
                                       !clr.contains(snapshot.data[id][0]['id'])?Colors.blueAccent:Colors.white
                                     ],
                                     radius: 2.0),
                               ),
                               child: Padding(
                                 padding: const EdgeInsets.all(3.0),
                                 child: CircleAvatar(
                                   radius: 20.0,
                                   backgroundColor: Colors.transparent,
                                   foregroundImage: NetworkImage('${snapshot.data[id][0]['link']}'),
                                 ),
                               ),
                             ),
                             onTap: (){
                               DBhelper.insertStory({'id':snapshot.data[id][0]['id']});
                               Navigator.push(context,MaterialPageRoute(builder: (BuildContext context)=>FullStorey(data: snapshot.data[id])));
                             },
                           );
                         }),
                 );
               }else{
                 return const Center(child: CircularProgressIndicator(),);
               }
            }),
        ),
      );
  }
}
