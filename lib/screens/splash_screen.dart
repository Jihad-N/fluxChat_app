import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:fluxchat/constants/consts.dart';
//import 'package:fluxchat/screens/login_screen.dart';
import 'package:fluxchat/screens/sign_up_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
        splashIconSize: MediaQuery.of(context).size.width*0.90,
        splash: Image(
          image:  AssetImage(splashLogo),
          fit: BoxFit.contain,
        ), 
        nextScreen: SignUpScreen(),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: primaryColor,
        duration: 3000,
        centered: true,
      ),
    );
  }
}
