import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:calling_in_game/model/user.dart' as model;

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signUp(
      {required String email,
      required String username,
      required String password,
      required int avatarIndex}) async {
    String res = "Có lỗi xảy ra";

    try {
      if (email.isNotEmpty || username.isNotEmpty || password.isNotEmpty) {
        // register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        model.User user = model.User(
            email: email,
            uid: cred.user!.uid,
            username: username,
            avatarIndex: avatarIndex);
        await _firestore.collection('users').doc(cred.user!.uid).set(
              user.toJson(),
            );

        res = 'success';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        res = 'Lỗi định dạng Email';
      } else if (e.code == 'weak-password') {
        res = 'Mật khẩu ít nhất 6 ký tự';
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<String> login({required String email, required String password}) async {
    String res = 'Có lỗi xảy ra!';

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(email: email, password: password);

        res = "success";
      }

    } catch(e) {
      res = e.toString();
    }
    return res;
  }


  Future<void> logOut() async {
    await _auth.signOut();
  }
}
