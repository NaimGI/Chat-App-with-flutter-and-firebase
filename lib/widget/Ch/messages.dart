import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'messge_bubble.dart';

class Message extends StatelessWidget {
  const Message({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final chtDocs = snapshot.data!.docs;
        final user = FirebaseAuth.instance.currentUser;
        return ListView.builder(
          reverse: true,
          itemCount: chtDocs.length,
          itemBuilder: (ctx, index) => MessBubble(
            chtDocs[index]["text"],
            chtDocs[index]["username"],
            chtDocs[index]["user_img"],
            chtDocs[index]["userId"] == user!.uid,
            key: ValueKey(chtDocs[index].reference.id),
          ),
        );
      },
      stream: FirebaseFirestore.instance
          .collection("chat")
          .orderBy("createAt", descending: true)
          .snapshots(),
    );
  }
}
