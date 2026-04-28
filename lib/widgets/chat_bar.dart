import 'package:flutter/material.dart';
import 'package:fluxchat/constants/consts.dart';

class ChatBar extends StatelessWidget {
  final String name;
  final String? avatar;

  const ChatBar({super.key, required this.name, this.avatar});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            radius: 25,
            backgroundImage: avatar != null && avatar!.isNotEmpty
                ? AssetImage(avatar!) // Fetches from URL
                : const Icon(Icons.person) as ImageProvider,
          ),
          const SizedBox(width: 15),
          Text(
            name,
            //style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Spacer(),
          Icon(Icons.message_outlined,size:22,color:primaryColor),
        ],
      ),
    );
  }
}
