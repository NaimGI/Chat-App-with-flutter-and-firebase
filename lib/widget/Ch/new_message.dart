import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class newMessage extends StatefulWidget {
  newMessage();

  @override
  State<newMessage> createState() => _newMessageState();
}

class _newMessageState extends State<newMessage> {
  final _controller = new TextEditingController();
  var _entermessage = "";
  void _sendMessege() async {
    FocusScope.of(context).unfocus();
    final user =
        FirebaseAuth.instance.currentUser; // get the user  authentificted
    final userD = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();
    ;

    FirebaseFirestore.instance.collection("chat").add({
      "text": _entermessage,
      "createAt": Timestamp.now(),
      "userId": user.uid,
      "username": userD['username'],
      "user_img": userD['user_img']
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: "Send a message..",
            ),
            onChanged: ((value) {
              setState(() {
                _entermessage = value;
              });
            }),
          )),
          IconButton(
            color: Theme.of(context).primaryColor,
            onPressed: _entermessage.trim().isEmpty ? null : _sendMessege,
            icon: const Icon(Icons.send),
          )
        ],
      ),
    );
  }
}
