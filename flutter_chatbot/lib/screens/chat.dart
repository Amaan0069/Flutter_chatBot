//Here we will write the code for displaying chat
//Once user logins or signup,
//New screen will be responsible to show the desired chats
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatbot/widgets/chat_messages.dart';
import 'package:flutter_chatbot/widgets/new_message.dart';

class chatscreen extends StatefulWidget {
  const chatscreen({super.key});

  @override
  State<chatscreen> createState() => _chatscreenState();
}

class _chatscreenState extends State<chatscreen> {
  void setupushnotifications() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    fcm.subscribeToTopic('chat');
    // kk.alert;
    //final token = await fcm.getToken();
  }

  @override
  void initState() {
    super.initState();
    setupushnotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Chats'),
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: Icon(
                  Icons.exit_to_app,
                  color: Theme.of(context).colorScheme.onBackground,
                ))
          ],
        ),
        body: const Column(
          children: [
            Expanded(
              child: chatmessages(),
            ),
            newmessage(),
          ],
        ));
  }
}
