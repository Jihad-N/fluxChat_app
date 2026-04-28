import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluxchat/widgets/chat_bar.dart';

class UsersList extends StatelessWidget {
   UsersList({super.key});
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      // Listen to the 'users' collection in real-time
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return const Center(child: Text('Error loading users'));
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Get list of documents from snapshot
        final users =
            snapshot.data?.docs.where((doc) {
              return doc.id != currentUserId; // Exclude current user
            }).toList() ?? [];

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            var userData = users[index].data() as Map<String, dynamic>;

            return ChatBar(
              name: userData['username'] ?? 'Unknown User',
              avatar: userData['avatar'],
            );
          },
        );
      },
    );
  }
}
