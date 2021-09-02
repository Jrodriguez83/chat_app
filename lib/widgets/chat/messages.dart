import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
            stream: Firestore.instance
                .collection('chat')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (ctx, chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final chatDocs = chatSnapshot.data.documents;
              return ListView.builder(
                reverse: true,
                itemCount: chatDocs.length,
                itemBuilder: (ctx, index) {

                  return FutureBuilder(
                      future: Firestore.instance
                          .collection('users')
                          .document(chatDocs[index]['userId'])
                          .get(),
                      builder: (ctx, instance) {
                        if(instance.connectionState == ConnectionState.waiting){
                          return Container(
                            child: Text('Loading Message...'),
                          );
                        }
                        return MessageBubble(
                          chatDocs[index]['text'],
                          chatDocs[index]['userId'] == futureSnapshot.data.uid,
                          chatDocs[index]['username'],
                          instance.data['profile_picture'],
                          key: ValueKey(chatDocs[index].documentID),
                        );
                      });
                },
              );
            });
      },
    );
  }
}
