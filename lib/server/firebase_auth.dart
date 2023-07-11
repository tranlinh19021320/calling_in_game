import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signUp({required String email, required String username, required String password, required int avatarIndex}) async {
    String res = "Có lỗi xảy ra";

    try {
      if (email.isNotEmpty || username.isNotEmpty || password.isNotEmpty) {
        // register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);

        
      }

    } catch(err) {
      res = err.toString();
    }

    return res;
  }
}