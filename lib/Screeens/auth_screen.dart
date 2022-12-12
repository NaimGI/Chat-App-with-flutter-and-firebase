import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../widget/auth_widget.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final _auth = FirebaseAuth.instance;
  var isLoding = false;
  late UserCredential authResult;
  void SubmitForm(String username, String password, String email, File _userimg,
      bool login) async {
    try {
      setState(() {
        isLoding = true;
      });
      if (login) {
        print(email);
        print(password);
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        final ref = FirebaseStorage.instance
            .ref()
            .child("user_img")
            .child(authResult.user!.uid + ".jpg");

        await ref.putFile(_userimg!);

        final url = await ref.getDownloadURL(); // get the img url uploaded
        await FirebaseFirestore.instance
            .collection("users")
            .doc(authResult.user!.uid)
            .set({
          "username": username,
          "email": email,
          "password": password,
          "user_img": url
        });
      }
    } on PlatformException catch (e) {
      var message = "an Error";
      if (e.message != null) {
        message = e.message!;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ));
      setState(() {
        isLoding = false;
      });
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(err.toString()),
        backgroundColor: Theme.of(context).errorColor,
      ));
      setState(() {
        isLoding = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: authwidget(SubmitForm, isLoding));
  }
}
