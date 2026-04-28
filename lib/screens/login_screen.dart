import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluxchat/constants/consts.dart';
import 'package:fluxchat/widgets/custom_button.dart';
import 'package:fluxchat/widgets/custom_text_form_field.dart';
import 'package:fluxchat/widgets/show_snack_bar.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> formkey = GlobalKey();

  String userName = '';

  String email = '';

  String password = '';

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      color: Color.fromARGB(255, 156, 172, 154),
      progressIndicator: CircularProgressIndicator(color: primaryColor),
      child: Scaffold(
        body: Container(
          color: primaryColor,
          child: Form(
            key: formkey,
            child: ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage(logo),
                      height: MediaQuery.of(context).size.height * 0.4,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            CustomTextFormField(
                              text: 'Username',
                              icon: Icon(Icons.person),
                              onChanged: (String data) {
                                userName = data;
                              },
                            ),
                            SizedBox(height: 20),
                            CustomTextFormField(
                              text: 'Email',
                              icon: Icon(Icons.email),
                              onChanged: (String data) {
                                email = data;
                              },
                            ),

                            SizedBox(height: 20),
                            CustomTextFormField(
                              text: 'Password',
                              isObscureText: true,
                              icon: Icon(Icons.lock),
                              onChanged: (String data) {
                                password = data;
                              },
                            ),
                            SizedBox(height: 20),
                            CustomTextButton(
                              text: 'Sign in',
                              onTap: () async {
                                if (formkey.currentState!.validate()) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  try {
                                    await signInwithEmailAndPassword();
                                    ShowSnackBar(
                                      context,
                                      'entered successfully',
                                    );
                                    // Navigator.pushNamed(
                                    //   context,
                                    //   'SetProfileIcon',
                                    // );
                                  } on FirebaseAuthException catch (e) {
                                    print(e.code);

                                    String message = 'An error occurred';
                                    if (e.code == 'user-not-found' ||
                                        e.code == 'wrong-password' ||
                                        e.code == 'invalid-credential') {
                                      message = 'Invalid email or password.';
                                    } else if (e.code == 'invalid-email') {
                                      message =
                                          'The email address is not valid.';
                                    }

                                    ShowSnackBar(context, message);
                                  }
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Don\'t have an account'),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, 'SignUpScreen');
                          },
                          child: Text(
                            'sign up',
                            style: TextStyle(color: profileColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<UserCredential> signInwithEmailAndPassword() {
    return FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
