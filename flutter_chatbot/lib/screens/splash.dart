//This screen will be our loading screen
//When logging in or signing up
//Firebase will be taking some time in the process
//So this screen will be responsible to show the loading widget
import 'package:flutter/material.dart';

class splashscreen extends StatelessWidget {
  const splashscreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Chats'),
      ),
      body: const Center(
        child: Text('Loading...'),
      ),
    );
  }
}
