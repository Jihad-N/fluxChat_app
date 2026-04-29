import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void showDeleteDialog(BuildContext context, String docId) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete Message'),
      content: const Text('Are you sure you want to delete this message?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            // delete from Firebase
            await FirebaseFirestore.instance
                .collection('messages')
                .doc(docId)
                .delete();
            
            if (context.mounted) Navigator.pop(context);
          },
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}
