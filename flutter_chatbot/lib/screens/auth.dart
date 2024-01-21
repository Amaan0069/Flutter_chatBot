//THis will be my screen for autentication of the users
//Like for entering the email and password
//This screen is for that purpose
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chatbot/widgets/user_image_picker.dart';

final _firebase = FirebaseAuth.instance;

class Authscreen extends StatefulWidget {
  const Authscreen({super.key});
  @override
  State<Authscreen> createState() {
    return _authscreenstate();
  }
}

// ignore: camel_case_types
class _authscreenstate extends State<Authscreen> {
  final formkey = GlobalKey<FormState>();
  var _islogin = true;
  var enteredemail = '';
  var enteredpass = '';
  var enteredusername = '';
  var isAuthente = false;
  File? selectedimage;
  void _submit() async {
    final isvalid = formkey.currentState!.validate();
    if (!isvalid || !_islogin && selectedimage == null) {
      return;
    }
    formkey.currentState!.save();
    //this if asle statement will handle the login and signup using firebase
    //
    try {
      //adding widget spinner to check for authent..
      setState(() {
        isAuthente = true;
      });
      if (_islogin) {
        //adding logic for he registered users
        final logincredd = await _firebase.signInWithEmailAndPassword(
            email: enteredemail, password: enteredpass);
        print(logincredd);
      } else {
        //using firebase to create new users
        //try catch block is used to carh exceptions
        //LIke email already in use
        final usercrenditials = await _firebase.createUserWithEmailAndPassword(
            email: enteredemail, password: enteredpass);
        //print(usercrenditials);
        final storgaeimage = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${usercrenditials.user!.uid}.jpg');
        await storgaeimage.putFile(selectedimage!);
        final imageurl = await storgaeimage.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(usercrenditials.user!.uid)
            .set({
          'username': enteredusername,
          'email': enteredemail,
          'Image_url': imageurl,
        });
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        //''''
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? 'Authentication Failed')));
      setState(() {
        isAuthente = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surfaceTint,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: const EdgeInsets.only(
                        top: 30, bottom: 40, left: 20, right: 20),
                    width: 200,
                    child: Image.asset("assets/images/chat.png")),
                Card(
                  margin: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                          key: formkey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (!_islogin)
                                UserImagePicker(
                                  onPickImage: (File pickedImage) {
                                    selectedimage = pickedImage;
                                  },
                                ),

                              TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Email Address'),
                                keyboardType: TextInputType.emailAddress,
                                autocorrect: false,
                                textCapitalization: TextCapitalization.none,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty ||
                                      !value.contains('@')) {
                                    return 'Please enter a Valid email address';
                                  }

                                  return null;
                                },
                                onSaved: (value) {
                                  enteredemail = value!;
                                },
                              ),
                              if(!_islogin)
                              TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Username'),
                                enableSuggestions: false,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.trim().length < 4) {
                                    return 'Please enter at least(4 characters long )';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  enteredusername = value!;
                                },
                              ),

                              TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Password'),
                                obscureText: true,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().length < 6) {
                                    return 'Password must be at least 6 charcters Long';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  enteredpass = value!;
                                },
                              ),
                              //Here we will be adding now our button logic to authen.
                              const SizedBox(
                                height: 12,
                              ),
                              if (isAuthente) const CircularProgressIndicator(),
                              if (!isAuthente)
                                ElevatedButton(
                                  onPressed: _submit,
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .onSecondary),
                                  child: Text(_islogin ? 'login' : 'Sign up'),
                                ),
                              if (!isAuthente)
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _islogin = !_islogin;
                                    });
                                  },
                                  child: Text(_islogin
                                      ? 'Create an account'
                                      : 'I already have an account.Login'),
                                )
                            ],
                          )),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
