import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluxchat/firebase_options.dart';
import 'package:fluxchat/screens/chat_screen.dart';
import 'package:fluxchat/screens/chats_and_profile.dart';
import 'package:fluxchat/screens/login_screen.dart';
import 'package:fluxchat/screens/set_profile_icon.dart';
import 'package:fluxchat/screens/sign_up_screen.dart';
import 'package:fluxchat/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const FluxChatApp());
}

class FluxChatApp extends StatelessWidget {
  const FluxChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        'SplashScreen': (context) => SplashScreen(),
        'LoginScreen': (context) => LoginScreen(),
        'SignUpScreen': (context) => SignUpScreen(),
        'SetProfileIcon': (context) => SetProfileIcon(),
        'chatsProfile': (context) => ChatsAndProfile(),
        //'ChatScreen': (context) => ChatScreen(),
      },
      initialRoute: 'SplashScreen',
    );
  }
}
