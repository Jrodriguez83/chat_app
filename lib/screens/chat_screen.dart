import 'package:chat_app/widgets/chat/messages.dart';
import 'package:chat_app/widgets/chat/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MikaApp'),
        actions: <Widget>[
          DropdownButton(
            icon: Icon(Icons.more_vert, color: Theme.of(context).primaryIconTheme.color,),
            items: [
              DropdownMenuItem(
                value: 'logout',
                  child: Row(
                children: <Widget>[
                  Icon(Icons.exit_to_app),
                  SizedBox(
                    width: 8,
                  ),
                  Text('Log Out'),
                ],
              ))
            ],
            onChanged: (value){
              if(value == 'logout'){
                FirebaseAuth.instance.signOut();
              }
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: Messages()),
          NewMessage(),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () {
      //     Firestore.instance
      //         .collection('chats/WCGb6yPMDPHjcHKJ1H9c/messages')
      //         .add({
      //       'text': 'This was added by pressing the +',
      //     });
      //   },
      // ),
    );
  }
}
