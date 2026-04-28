import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluxchat/constants/consts.dart';
import 'package:fluxchat/widgets/custom_button.dart';
import 'package:fluxchat/widgets/custom_text_form_field.dart';
import 'package:fluxchat/widgets/show_snack_bar.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

// ignore: must_be_immutable
class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> formkey = GlobalKey();

  String userName = '';

  String email = '';

  String password = '';

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return users.doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
            'username': userName, // John Doe
            'email': email, // Stokes and Sons
            'avatar': '', // 42
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    return ModalProgressHUD(
      inAsyncCall: isLoading,
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
                              text: 'Sign Up',
                              onTap: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                if (formkey.currentState!.validate()) {
                                  try {
                                    await CreateUser();
                                    addUser();
                                    ShowSnackBar(
                                      context,
                                      'Account created successfully',
                                    );
                                    Navigator.pushNamed(
                                      context,
                                      'SetProfileIcon',
                                    );
                                  } on FirebaseAuthException catch (e) {
                                    if (e.code == 'weak-password') {
                                      ShowSnackBar(
                                        context,
                                        'The password provided is too weak.',
                                      );
                                    } else if (e.code ==
                                        'email-already-in-use') {
                                      ShowSnackBar(
                                        context,
                                        'The account already exists for that email.',
                                      );
                                    }
                                  } catch (e) {
                                    ShowSnackBar(
                                      context,
                                      'An error occurred. Please try again.',
                                    );
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
                        Text('Already have an account'),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, 'LoginScreen');
                          },
                          child: Text(
                            'sign in',
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

  Future<UserCredential> CreateUser() {
    return FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
