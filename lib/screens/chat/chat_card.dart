import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:koocho/screens/chat/chat_conversation_screen.dart';
import 'package:koocho/services/firebase_services.dart';

import 'package:intl/intl.dart';

class ChatCard extends StatefulWidget {
  final Map<String, dynamic> chatData;

  ChatCard(this.chatData);

  @override
  _ChatCardState createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  FirebaseService _service = FirebaseService();

  DocumentSnapshot doc;

  String _lastChatDate = '';

  @override
  void initState() {
    getProductDetails();
    getChatTime();
    super.initState();
  }

  getProductDetails() {
    _service
        .getProductDetails(widget.chatData['product']['productId'])
        .then((value) {
      setState(() {
        doc = value;
      });
    });
  }

  getChatTime() {
    var _date = DateFormat.yMMMd().format(
        DateTime.fromMicrosecondsSinceEpoch(widget.chatData['lastChatTime']));

    var _today = DateFormat.yMMMd().format(DateTime.fromMicrosecondsSinceEpoch(
        DateTime.now().microsecondsSinceEpoch));

    if (_date == _today) {
      setState(() {
        _lastChatDate = 'Today';
      });
    } else {
      setState(() {
        _lastChatDate = _date.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return doc == null
        ? Container()
        : Container(
            child: Stack(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                ListTile(
                  onTap: () {
                    _service.messages
                        .doc(widget.chatData['chatRoomId'])
                        .update({
                      'read': 'true',
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => ChatConversations(
                          chatRoomId: widget.chatData['chatRoomId'],
                        ),
                      ),
                    );
                  },
                  shape: Border(
                    bottom: BorderSide(
                      color: Colors.blue.shade300,
                    ),
                  ),
                  leading: Container(
                      width: 60,
                      height: 60,
                      child: Image.network(doc['images'][0])),
                  title: Text(
                    doc['title'],
                    style: TextStyle(
                        fontWeight: widget.chatData['read'] == false
                            ? FontWeight.bold
                            : FontWeight.normal),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doc['description'],
                        maxLines: 1,
                      ),
                      if (widget.chatData['lastChat'] != null)
                        Text(
                          widget.chatData['lastChat'],
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.more_vert_sharp,
                    ),
                    onPressed: () {},
                  ),
                ),
                Positioned(
                  right: 10.0,
                  top: 10.0,
                  child: Text(_lastChatDate),
                )
              ],
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.blue,
                ),
              ),
            ),
          );
  }
}
