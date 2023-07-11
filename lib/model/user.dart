import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String username;
  final int avatarIndex;

  const User({
    required this.email,
    required this.uid,
    required this.username,
    required this.avatarIndex,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'uid': uid,
        'username': username,
        'avatarIndex': avatarIndex,
      };

  static User fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;

    return User(
        email: snap['email'],
        uid: snap['uid'],
        username: snap['username'],
        avatarIndex: snap['avatarIndex'],);
  }
}
