import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../server/firebase_firestore.dart';
import '../utils/utils.dart';

class JoinRoomDialog extends StatefulWidget {
  const JoinRoomDialog({super.key});

  @override
  State<JoinRoomDialog> createState() => _JoinRoomDialogState();
}

class _JoinRoomDialogState extends State<JoinRoomDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  late FocusNode _nameFocus;
  late FocusNode _idFocus;
  final FocusNode _passwordFocus = FocusNode();

  int _isStateRoom = IS_DEFAULT;
  int _isStatePassword = IS_DEFAULT;

  bool _isloading = false;
  String roomUid = "";

  @override
  void initState() {
    super.initState();
    _nameFocus = FocusNode();
    _nameFocus.addListener(() {
      if (!_nameFocus.hasFocus && _nameController.text != "") {
        checkAlreadyRoombyName();
      }
    });

    _idFocus = FocusNode();
    _idFocus.addListener(() {
      if (!_idFocus.hasFocus && int.parse(_idController.text) != 0) {
        checkAlreadyRoombyID();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _nameController.dispose();
    _idController.dispose();
    _passwordController.dispose();

    _nameFocus.dispose();
    _idFocus.dispose();
    _passwordFocus.dispose();
  }

  joinRoom() async {
    setState(() {
      _isloading = true;
    });
    try {
      String res = await FirebaseStore().joinRoom(
          uid: roomUid,
          useruid: FirebaseAuth.instance.currentUser!.uid,
          password: _passwordController.text);
      setState(() {
        _isloading = false;
      });
      if (context.mounted) {
        switch (res) {
          case "success":
            {
              showSnackBar(
                  context, "Đã tham gia phòng ${_nameController.text}", false);
              Navigator.pop(context);
            }
            break;

          case "had-room":
            {
              showSnackBar(context,
                  "Bạn đang trong phòng ${_nameController.text}", false);
              setState(() {
                
                _idController.clear();
                _nameController.clear();
                _passwordController.clear();

                _isStateRoom = IS_DEFAULT;
                _isStatePassword = IS_DEFAULT;
              });
            }
            break;
          case "password-error":
            {
              showSnackBar(context, "Mật khẩu sai", true);
              setState(() {
                _isStatePassword = IS_ERROR;
              });
            }
            break;
          default:
            {
              showSnackBar(context, res, true);
            }
            break;
        }
      }
    } catch (e) {
      showSnackBar(context, e.toString(), true);
    }
  }

  checkAlreadyRoombyName() async {
    try {
      var snap = await FirebaseFirestore.instance
          .collection('rooms')
          .where('nameroom', isEqualTo: _nameController.text)
          .get();

      if (snap.docs.isNotEmpty) {
        setState(() {
          _isStateRoom = IS_CORRECT;
          roomUid = (snap.docs.first.data() as dynamic)['uid'];
          _idController.text = "${(snap.docs.first.data() as dynamic)['id']}";
        });
      } else {
        setState(() {
          _isStateRoom = IS_ERROR;
          _idController.clear();
        });
      }
    } catch (e) {
      showSnackBar(context, e.toString(), true);
    }
  }

  checkAlreadyRoombyID() async {
    try {
      var snap = await FirebaseFirestore.instance
          .collection('rooms')
          .where('id', isEqualTo: int.parse(_idController.text))
          .get();

      if (snap.docs.isNotEmpty) {
        setState(() {
          _isStateRoom = IS_CORRECT;
          roomUid = (snap.docs.first.data() as dynamic)['uid'];
          _nameController.text =
              (snap.docs.first.data() as dynamic)['nameroom'];
        });
      } else {
        setState(() {
          _isStateRoom = IS_ERROR;
          _nameController.clear();
        });
      }
    } catch (e) {
      showSnackBar(context, e.toString(), true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Container(
        alignment: Alignment.center,
        child: const Text('Tham gia phòng'),
      ),
      content: (_isloading)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        autofocus: true,
                        focusNode: _nameFocus,
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Tên phòng',
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: (_isStateRoom == IS_DEFAULT)
                                ? greyColor
                                : (_isStateRoom == IS_CORRECT)
                                    ? greenColor
                                    : redColor,
                          )),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                            color: blueColor,
                          )),
                        ),
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(_passwordFocus);
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text("hoặc"),
                      ),
                      TextFormField(
                        focusNode: _idFocus,
                        controller: _idController,
                        decoration: InputDecoration(
                          labelText: 'ID',
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: (_isStateRoom == IS_DEFAULT)
                                ? greyColor
                                : (_isStateRoom == IS_CORRECT)
                                    ? greenColor
                                    : redColor,
                          )),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                            color: blueColor,
                          )),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(_passwordFocus);
                        },
                      ),
                      (_isStateRoom == IS_DEFAULT)
                          ? const Text("")
                          : (_isStateRoom == IS_ERROR)
                              ? const Text(
                                  "Không tìm thấy phòng!",
                                  style: TextStyle(color: redColor),
                                )
                              : Text(
                                  "Tên phòng: ${_nameController.text}, ID: ${_idController.text}",
                                  style: const TextStyle(color: greenColor),
                                ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        focusNode: _passwordFocus,
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Mật khẩu',
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: (_isStatePassword == IS_DEFAULT) ?greyColor : redColor,
                          )),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                            color: blueColor,
                          )),
                        ),
                        onEditingComplete: joinRoom,
                      ),
                      (_isStatePassword == IS_DEFAULT)
                          ? const Text("")
                          : const Text(
                              "Mật khẩu sai!",
                              style: TextStyle(color: redColor),
                            ),
                      const SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                ),
              ],
            ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Hủy',
              style: TextStyle(color: redColor),
            )),
        TextButton(
            onPressed: joinRoom,
            child: const Text(
              'Join',
              style: TextStyle(color: blueColor),
            )),
      ],
    );
  }
}
