import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  final String uid;
  final String ownuseruid;
  final String nameroom;
  final String password;
  final int id;

  const Room({
    required this.uid,
    required this.ownuseruid,
    required this.nameroom,
    required this.password,
    required this.id,
  });

  Map<String, dynamic> toJson() => {
        'uid' : uid,
        'ownuserid' : ownuseruid,
        'nameroom' : nameroom,
        'password' : password,
        'id' : id,
      };

  static Room fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;

    return Room(
      uid: snap['uid'],
      ownuseruid: snap['ownuseruid'],
      nameroom: snap['nameroom'],
      password: snap['password'],
      id: snap['id'],
    );
  }
}
