import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluxchat/models/user_model.dart';

class UserServices {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  // Get user ONCE (for FutureBuilder)
  Future<UserModel?> getUser(String uid) async {
    try {
      final doc = await users.doc(uid).get();

      if (doc.exists) {
        return UserModel.fromMap(
          doc.data() as Map<String, dynamic>,
        );
      }
      return null;
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }
}