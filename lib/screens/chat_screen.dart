import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluxchat/constants/app_text_styles.dart';
import 'package:fluxchat/constants/consts.dart';
import 'package:fluxchat/models/message.dart';
import 'package:fluxchat/widgets/chat_bubble.dart';
import 'package:fluxchat/widgets/show_delete_dialog.dart';

class ChatScreen extends StatelessWidget {
  final CollectionReference messages = FirebaseFirestore.instance.collection(
    'messages',
  );
  ChatScreen({super.key, required this.friendEmail});
  final String friendEmail;
  final TextEditingController controller = TextEditingController();
  final ScrollController _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    var fEmail = friendEmail.toLowerCase();
    var currentUserEmail = FirebaseAuth.instance.currentUser!.email;

    List<String> ids = [currentUserEmail!, fEmail];
    ids.sort(); // Sort the list to ensure consistent order
    String chatRoomId = ids.join("_");

    return StreamBuilder<QuerySnapshot>(
      stream: messages
          .where('chatRoomId', isEqualTo: chatRoomId)
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        List<Message> messageList = [];
        if (snapshot.hasData) {
          for (var doc in snapshot.data!.docs) {
            messageList.add(
              Message.fromJson(doc.data() as Map<String, dynamic>),
            );
          }
        }
        return Scaffold(
          appBar: AppBar(
            foregroundColor: Colors.white,
            backgroundColor: primaryColor,
            title: Image(
              image: AssetImage('assets/images/fluxchat-logo.png'),
              height: 70,
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: messageList.isEmpty
                    ? Center(
                        child: SingleChildScrollView(
                          
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/hello.png', 
                                height: 150,
                                errorBuilder: (context, error, stackTrace) {
                                  
                                  return Icon(
                                    Icons.chat_bubble_outline_rounded,
                                    size: 100,
                                    color: primaryColor.withOpacity(0.2),
                                  );
                                },
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No messages yet..',
                                style: AppTextStyles.bodyText
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'start chat, say hello 👋',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        reverse: true,
                        controller: _controller,
                        itemCount: messageList.length,
                        itemBuilder: (BuildContext context, int index) {
                          var doc = snapshot.data!.docs[index];
                          var data = doc.data() as Map<String, dynamic>;
                          Message message = Message.fromJson(data);
                          String docId = doc.id;
                          return GestureDetector(
                            onLongPress: () {
                              showDeleteDialog(context, docId);
                            },
                            child: message.id == currentUserEmail
                                ? ChatBubble(
                                    color: primaryColor.withOpacity(0.5),
                                    message: messageList[index],
                                  )
                                : ChatBubbleForFriend(
                                    color: profileColor.withOpacity(0.5),
                                    message: messageList[index],
                                  ),
                          );
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 16,
                ),
                child: TextField(
                  controller: controller,
                  onSubmitted: (data) {
                    messages.add({
                      'message': data, // or controller.text
                      'createdAt': DateTime.now(),
                      'id': currentUserEmail, // who sent the message
                      'chatRoomId': chatRoomId,
                    });
                    controller.clear();
                    _controller.animateTo(
                      // _controller.position.maxScrollExtent
                      0,
                      duration: Duration(seconds: 5),
                      curve: Curves.fastOutSlowIn,
                    );
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(255, 228, 168, 216),
                    suffixIcon: Container(
                      margin: EdgeInsets.only(right: 8),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(
                              255,
                              228,
                              93,
                              201,
                            ).withOpacity(0.5),
                            blurRadius: 2,
                            spreadRadius: 0.5,
                          ),
                        ],

                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: InkWell(
                        onTap: () {
                          messages.add({
                            'message': controller.text,
                            'createdAt': DateTime.now(),
                            'id': currentUserEmail,
                            'chatRoomId': chatRoomId,
                          });
                          controller.clear();
                          _controller.animateTo(
                            // _controller.position.maxScrollExtent
                            0,
                            duration: Duration(seconds: 5),
                            curve: Curves.fastOutSlowIn,
                          );
                        },
                        child: Icon(
                          Icons.send_rounded,
                          color: Color.fromARGB(255, 166, 39, 141),
                        ),
                      ),
                    ),
                    hintText: 'Send Message',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                      borderSide: BorderSide(color: primaryColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
