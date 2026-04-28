import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluxchat/constants/app_text_styles.dart';
import 'package:fluxchat/constants/consts.dart';
import 'package:fluxchat/models/user_model.dart';
import 'package:fluxchat/services/user_services.dart';
import 'package:fluxchat/widgets/users_list.dart';

class ChatsAndProfile extends StatelessWidget {
  ChatsAndProfile({super.key});
  final userService = UserServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            color: profileColor,
            child: FutureBuilder<UserModel?>(
              future: userService.getUser(
                FirebaseAuth.instance.currentUser!.uid,
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                final user = snapshot.data!;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: user.avatar.isNotEmpty
                            ? AssetImage(user.avatar)
                            : null,
                        child: user.avatar.isEmpty
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Hi, ${user.username}', style: AppTextStyles.black18),
                            Text('You can chat, message other users and enjoy right now!', style: AppTextStyles.bodyText, ),
                          ],
                        ),
                      ),
                      
                    ],
                  ),
                );
              },
            ),
          ),
          Expanded(child:  UsersList()),
           
        ],
      ),
    );
  }
}

// class ChatBar extends StatelessWidget {
//   ChatBar({super.key});
//   final userService = UserServices();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//             height: 75,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.black, width: 0.5),
//             ),
//             child: FutureBuilder<UserModel?>(
//               future: userService.getUser(
//                 FirebaseAuth.instance.currentUser!.uid,
//               ),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData || snapshot.data == null) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 final user = snapshot.data!;

//                 return Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: Row(
//                     children: [
//                       CircleAvatar(
//                         radius: 30,
//                         backgroundImage: user.avatar.isNotEmpty
//                             ? AssetImage(user.avatar)
//                             : null,
//                         child: user.avatar.isEmpty
//                             ? const Icon(Icons.person)
//                             : null,
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(child: Text(user.username,)),
//                       Icon(Icons.message_outlined,size:22,color:primaryColor),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           );
//   }
// }