import 'dart:async';
import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:paint/constant.dart';
import 'Message.dart';
import 'package:http/http.dart' as http;

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _controller = TextEditingController();
  String? androidId;

  @override
  initState() {
    super.initState();
    getAndroidId();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      getMessages();
    });
  }

  getAndroidId() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.androidInfo;
    androidId = deviceInfo.androidId;
  }

  getMessages() async {
    var data = await http
        .get(Uri.parse("http://bhatakeed.in/iust/chat/index.php?get=1"));
    if (data.statusCode == 200) {
      messages.clear();
      jsonDecode(data.body)['data'].forEach((value) {
        setState(() {
          messages.add(Message(
              text: value['text'],
              date: DateTime.parse(value['date']),
              isSentByMe: androidId == value['dev_id'] ? true : false,
              name: value['person_name']
          ));
        });
      });
    }
  }

  Future<int> setMessages(msg) async {
    var data = await http.post(
        Uri.parse("http://bhatakeed.in/iust/chat/index.php"),
        body: {"set": "$androidId,,,,$msg"});
    if (data.statusCode == 200) {
      return 1;
    } else {
      return 0;
    }
  }

  List<Message> messages = [
    Message(
        text: 'Wellcome',
        date: DateTime.now().subtract(const Duration(minutes: 1)),
        isSentByMe: false,
        name: "Admin"
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Ask Me"),
          flexibleSpace: Constant.KFlexibleSpaceBar,
        ),
        body: Column(
          children: [
            Expanded(
                flex: 1,
                child: GroupedListView<Message, DateTime>(
                  reverse: true,
                  order: GroupedListOrder.DESC,
                  useStickyGroupSeparators: true,
                  floatingHeader: true,
                  padding: const EdgeInsets.all(8.0),
                  elements: messages,
                  groupBy: (message) => DateTime(
                      message.date.year, message.date.month, message.date.day),
                  groupHeaderBuilder: (Message message) => SizedBox(
                    height: 40,
                    child: Center(
                      child: Card(
                        color: Colors.green,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            DateFormat.yMMMd().format(message.date),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  itemBuilder: (context, Message message) => Align(
                    alignment: message.isSentByMe
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade400,
                              offset: const Offset(0, 1),
                            ),
                          ],
                          color: message.isSentByMe
                              ? Colors.blueAccent
                              : Colors.white,
                          borderRadius: message.isSentByMe
                              ? const BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  topLeft: Radius.circular(30),
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30))
                              : const BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30))),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          "[${message.name}]:  ${message.text}",
                          style: TextStyle(
                              color: message.isSentByMe
                                  ? Colors.white
                                  : Colors.blue),
                        ),
                      ),
                    ),
                  ),
                )),
            Row(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(30))
                    ),
                    child: TextFormField(
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Text is empty';
                        }
                        return null;
                      },
                      controller: _controller,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(12.0),
                          hintText: 'Enter You Message'),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    var isSent = 0;
                    var snackBar = const SnackBar(content: Text('Message Sent'));
                    if(_controller.text.isNotEmpty){
                      isSent = await setMessages(_controller.text);
                      _controller.text='';
                      isSent==1?ScaffoldMessenger.of(context).showSnackBar(snackBar):null;
                    }
                  },
                  child: const Icon(Icons.send, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(10),
                    backgroundColor: Colors.green, // <-- Button color
                    foregroundColor: Colors.red, // <-- Splash color
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
