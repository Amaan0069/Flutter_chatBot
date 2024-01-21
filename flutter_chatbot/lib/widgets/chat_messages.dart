//here we will write the code for our app
//to show the all text messages avaliable
//in the app
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatbot/widgets/message_bubble.dart';

class chatmessages extends StatelessWidget {
  const chatmessages({super.key});

  @override
  Widget build(BuildContext context) {
    final autenticuser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Chat')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, chatsnapshots) {
          if (chatsnapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!chatsnapshots.hasData || chatsnapshots.data!.docs.isEmpty) {
            return const Center(
              child: Text('No messages found'),
            );
          }
          if (chatsnapshots.hasError) {
            return const Center(
              child: Text('Something went wrong...'),
            );
          }
          final loadedmessages = chatsnapshots.data!.docs;
          return ListView.builder(
              padding: const EdgeInsets.only(bottom: 40, left: 30, right: 30),
              reverse: true,
              itemCount: loadedmessages.length,
              itemBuilder: (ctx, index) {
                final chatmess = loadedmessages[index].data();
                final nextchatmessage = index + 1 < loadedmessages.length
                    ? loadedmessages[index + 1].data()
                    : null;
                final currentmessageid = chatmess['User-Id'];
                final nextmessageid =
                    nextchatmessage != null ? nextchatmessage['User-Id'] : null;
                final nextuserid = currentmessageid == nextmessageid;
                if (nextuserid) {
                  return MessageBubble.next(
                      message: chatmess['Text'],
                      isMe: autenticuser.uid == currentmessageid);
                } else {
                  return MessageBubble.first(
                      userImage: chatmess['UserImage'],
                      username: chatmess['username'],
                      message: chatmess['Text'],
                      isMe: autenticuser.uid == currentmessageid);
                }
              });
        });
  }
}
