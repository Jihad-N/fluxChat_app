import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluxchat/constants/consts.dart';
import 'package:fluxchat/models/message.dart';
import 'package:fluxchat/widgets/chat_bubble.dart';

class ChatScreen extends StatelessWidget {
  final CollectionReference messages = FirebaseFirestore.instance.collection(
    'messages',
  );
  ChatScreen({super.key});
  final TextEditingController controller = TextEditingController();
  final ScrollController _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    var email = FirebaseAuth.instance.currentUser!.email;
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          List<Message> messageList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            var data = snapshot.data!.docs[i].data() as Map<String, dynamic>;

            // إرسال الـ Map للـ factory
            messageList.add(Message.fromJson(data));
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
                  child: ListView.builder(
                    reverse: true,
                    controller: _controller,
                    itemCount: messageList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return messageList[index].id == email
                          ? ChatBubble(
                              color: primaryColor.withOpacity(0.5),
                              message: messageList[index],
                            )
                          : ChatBubbleForFriend(
                              color: profileColor.withOpacity(0.5),
                              message: messageList[index],
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
                        'message': data,
                        'createdAt': DateTime.now(),
                        'id': email,
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
                              'id': email,
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
        } else {
          return Text('Loading...');
        }
      },
    );
  }
}
