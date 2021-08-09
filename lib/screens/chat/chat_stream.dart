import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_2.dart';
import 'package:koocho/services/firebase_services.dart';

import 'package:intl/intl.dart';

class ChatStream extends StatefulWidget {
  final String chatRoomId;
  ChatStream(this.chatRoomId);

  //

  @override
  _ChatStreamState createState() => _ChatStreamState();
}

class _ChatStreamState extends State<ChatStream> {
  FirebaseService _service = FirebaseService();

  Stream chatMessageStream;

  DocumentSnapshot chatDoc;

  @override
  void initState() {
    _service.getChat(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });

    _service.messages.doc(widget.chatRoomId).get().then((value) {
      setState(() {
        chatDoc = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 60),
      child: StreamBuilder<QuerySnapshot>(
        stream: chatMessageStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
            );
          }

          return snapshot.hasData
              ? Column(
                  children: [
                    if (chatDoc != null)
                      ListTile(
                        title: Text(chatDoc['product']['title']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(chatDoc['product']['price']),
                            SizedBox(
                              width: 100,
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: Container(
                        color: Colors.blue,
                        child: ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              String sentBy =
                                  snapshot.data.docs[index]['sentBy'];
                              String me = _service.user.uid;

                              //add chat time
                              String lastChatDate;
                              //Last chat date format\\ 03.07.2021

                              var _date = DateFormat.yMMMd().format(
                                  DateTime.fromMicrosecondsSinceEpoch(
                                      snapshot.data.docs[index]['time']));
                              var _today = DateFormat.yMMMd().format(
                                  DateTime.fromMicrosecondsSinceEpoch(
                                      DateTime.now().microsecondsSinceEpoch));

                              if (_date == _today) {
                                lastChatDate = DateFormat('hh:mm').format(
                                    DateTime.fromMicrosecondsSinceEpoch(
                                        snapshot.data.docs[index]['time']));
                                //Format\\10.37
                              } else {
                                lastChatDate = _date.toString();
                              }

                              return Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    ChatBubble(
                                      alignment: sentBy == me
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      backGroundColor: sentBy == me
                                          ? Colors.green
                                          : Colors.yellow,
                                      child: Container(
                                        constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                        ),
                                        child: Text(
                                          snapshot.data.docs[index]['message'],
                                          style: TextStyle(
                                              color: sentBy == me
                                                  ? Colors.white
                                                  : Colors.black),
                                        ),
                                      ),
                                      clipper: ChatBubbleClipper2(
                                          type: sentBy == me
                                              ? BubbleType.sendBubble
                                              : BubbleType.receiverBubble),
                                    ),
                                    Align(
                                      alignment: sentBy == me
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: Text(
                                        lastChatDate,
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                    ),
                  ],
                )
              : Container();
        },
      ),
    );
  }
}
