import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  final String username;
  final String email;
  final String avatar;

  UserModel({
    required this.username,
    required this.email,
    required this.avatar,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      avatar: map['avatar'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'name': username, 'email': email, 'avatar': avatar};
  }
}
