import 'package:calling_in_game/server/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../model/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final Auth _auth = Auth();
  User get getUser => _user!;

  refreshUser() async {

    User user = await _auth.getUserDetails();
    _user = user;
    notifyListeners();

  }
}