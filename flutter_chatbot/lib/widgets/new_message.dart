//logic to show a   message when we click on it
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class newmessage extends StatefulWidget {
  const newmessage({super.key});
  @override
  State<newmessage> createState() {
    return _newmessage();
  }
}

class _newmessage extends State<newmessage> {
  var messagecontroller = TextEditingController();
  void submitmessage() async {
     
    final enteredmessage = messagecontroller.text;

    if (enteredmessage.trim().isEmpty) {
      return;
    }
    //send emssage to firebase
     FocusScope.of(context).unfocus();
     messagecontroller.clear();
    final user = FirebaseAuth.instance.currentUser!;
    final userdata = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    FirebaseFirestore.instance.collection('Chat').add({
      'Text': enteredmessage,
      'createdAt': Timestamp.now(),
      'User-Id': user.uid,
      'username': userdata.data()!['username'],
      'UserImage': userdata.data()!['Image_url']
    });
  }

  @override
  void dispose() {
    messagecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 11, bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messagecontroller,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(labelText: 'Send a message..'),
            ),
          ),
          IconButton(
            onPressed: submitmessage,
            icon: const Icon(Icons.send),
            color: Theme.of(context).primaryColorDark,
          )
        ],
      ),
    );
  }
}
