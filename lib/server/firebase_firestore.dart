import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../model/voice_room.dart';

class FirebaseStore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String createRoom(
      {required String ownuseruid,
      required String nameroom,
      required String password,
      required int id}) {
    String res = "Có lỗi xảy ra";
    String uid = const Uuid().v1();

    Room room = Room(
        uid: uid,
        ownuseruid: ownuseruid,
        nameroom: nameroom,
        password: password,
        id: id);

    _firestore.collection('rooms').doc(uid).set(room.toJson());
    joinRoom(uid: uid, useruid: ownuseruid, password: password);
    res = "success";
    return res;
  }

  Future<String> deleteRoom(
      {required String uid, required String ownuserid}) async {
    String res = '';

    try {
      var snap = _firestore.collection("rooms").doc(uid).get();
      if ((snap as dynamic)['ownuseruid'] == ownuserid) {
        await _firestore.collection('rooms').doc(uid).delete();
        res = "success";
      } else {
        res = "notowner";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> joinRoom(
      {required String uid,
      required String useruid,
      required String password}) async {
    String res = "";
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(useruid).get();
      List rooms = (snapshot.data()! as dynamic)['rooms'];

      DocumentSnapshot snapRoom =
          await _firestore.collection('rooms').doc(uid).get();
      String password0 = (snapRoom.data()! as dynamic)['password'];
      if (password0 == password) {
        if (!rooms.contains(uid)) {
          await _firestore.collection('users').doc(useruid).update({
            'rooms': FieldValue.arrayUnion([uid]),
          });
        } else {
          res = "had-room";
        }
      } else {
        res = "password-error";
      }
    } catch (e) {
      print(e.toString());
    }

    return res;
  }

  outRoom({required String uid, required String useruid}) async {
    try {
      await _firestore.collection('users').doc(useruid).update({
        'rooms': FieldValue.arrayRemove([uid]),
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
