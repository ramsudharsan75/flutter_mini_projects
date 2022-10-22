import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = chatSnapshot.data?.docs;

        return ListView.builder(
          reverse: true,
          itemCount: chatDocs?.length,
          itemBuilder: (ctx, index) => MessageBubble(
            chatDocs?[index].get('text'),
            (chatDocs?[index].get('userId') ==
                FirebaseAuth.instance.currentUser!.uid),
            chatDocs?[index].get('username'),
            chatDocs?[index].get('userImage'),
            key: ValueKey(chatDocs?[index].id),
          ),
        );
      },
    );
  }
}
