import 'package:flutter/material.dart';
import 'package:fluxchat/constants/consts.dart';
import 'package:fluxchat/screens/chat_screen.dart';

class ChatBar extends StatelessWidget {
  final String name;
  final String? avatar;
  final String email;

  const ChatBar({
    super.key,
    required this.name,
    this.avatar,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(friendEmail: email),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: avatar != null && avatar!.isNotEmpty
                  ? AssetImage(avatar!) // Asset image
                  : null,
              child: avatar == null || avatar!.isEmpty
                  ? const Icon(Icons.person)
                  : null,
            ),
            const SizedBox(width: 15),
            Text(
              name,
              //style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Icon(Icons.message_outlined, size: 22, color: primaryColor),
          ],
        ),
      ),
    );
  }
}
