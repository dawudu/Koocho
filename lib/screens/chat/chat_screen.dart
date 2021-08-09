import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:koocho/screens/chat/chat_card.dart';
import 'package:koocho/services/firebase_services.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();

    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.yellow,
          title: Text(
            "Chats",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          bottom: TabBar(
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            labelColor: Colors.black,
            indicatorWeight: 6,
            indicatorColor: Colors.blue,
            tabs: [
              Tab(text: 'ALL'),
              Tab(text: 'BUYING'),
              Tab(text: 'SELLING'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: _service.messages
                    .where('users', arrayContains: _service.user.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.blue,
                        ),
                      ),
                    );
                  }

                  return ListView(
                    //change to "new" listview
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      return new ChatCard(data);
                    }).toList(),
                  );
                },
              ),
            ),
            Container(),
            Container(),
          ],
        ),
      ),
    );
  }
}
