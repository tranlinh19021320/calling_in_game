import 'package:calling_in_game/server/firebase_firestore.dart';
import 'package:calling_in_game/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateNewRoomDialog extends StatefulWidget {
  const CreateNewRoomDialog({super.key});

  @override
  State<CreateNewRoomDialog> createState() => _CreateNewRoomDialogState();
}

class _CreateNewRoomDialogState extends State<CreateNewRoomDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late FocusNode _nameFocus;
  final FocusNode _passwordFocus = FocusNode();

  int _isStateNameRoom = IS_DEFAULT;

  bool _isloadingID = false;
  bool _isloading = false;
  int id = 10;

  @override
  void initState() {
    super.initState();
    getRoomRandomID();
    _nameFocus = FocusNode();
    _nameFocus.addListener(() {
      if (!_nameFocus.hasFocus && _nameController.text != "") {
        checkAlreadyRoom();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _nameController.dispose();
    _passwordController.dispose();

    _nameFocus.dispose();
    _passwordFocus.dispose();
  }

  createRoom() {
    setState(() {
      _isloading = true;
      _passwordFocus.unfocus();
    });

    String res = FirebaseStore().createRoom(
        ownuseruid: FirebaseAuth.instance.currentUser!.uid,
        nameroom: _nameController.text,
        password: _passwordController.text,
        id: id);

    setState(() {
      _isloading = false;
    });
    if (context.mounted) {
      if (res == 'success') {
        showSnackBar(context, "Tạo phòng thành công!", false);
        Navigator.pop(context);
      } else {
        showSnackBar(context, res, true);
      }
    }
  }

  checkAlreadyRoom() async {
    try {
      var snap = await FirebaseFirestore.instance
          .collection('rooms')
          .where('nameroom', isEqualTo: _nameController.text)
          .get();

      if (snap.docs.isNotEmpty) {
        setState(() {
          _isStateNameRoom = IS_CORRECT;
        });
      } else {
        setState(() {
          _isStateNameRoom = IS_ERROR;
        });
      }
    } catch (e) {
      showSnackBar(context, e.toString(), true);
    }
  }

  getRoomRandomID() async {
    int findid = randomId();
    try {
      var snap = await FirebaseFirestore.instance
          .collection("rooms")
          .where('id', isEqualTo: findid)
          .get();
      if (snap.docs.isNotEmpty) {
        setState(() {
          _isloadingID = true;
        });
        getRoomRandomID();
      } else {
        setState(() {
          _isloadingID = false;
          id = findid;
        });
      }
      ;
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
        child: const Text('Tạo phòng mới'),
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
                            color: (_isStateNameRoom == IS_DEFAULT)
                                ? greyColor
                                : (_isStateNameRoom == IS_ERROR)
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
                      (_isStateNameRoom == IS_DEFAULT)
                          ? const Text("")
                          : (_isStateNameRoom == IS_ERROR)
                              ? const Text(
                                  "Chưa có phòng!",
                                  style: TextStyle(color: greenColor),
                                )
                              : const Text(
                                  "Đã có phòng trùng tên",
                                  style: TextStyle(color: redColor),
                                ),
                      TextFormField(
                        focusNode: _passwordFocus,
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Mật khẩu',
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: greyColor,
                          )),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                            color: blueColor,
                          )),
                        ),
                        onEditingComplete: createRoom,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      (!_isloadingID)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('id : $id'),
                                IconButton(
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(
                                        text: "$id",
                                      )).then((value) => showSnackBar(
                                          context, "Đã copy ID!", false));
                                    },
                                    icon: const Icon(
                                      Icons.copy_outlined,
                                      size: 16,
                                    ))
                              ],
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
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
            onPressed: createRoom,
            child: const Text(
              'Tạo',
              style: TextStyle(color: blueColor),
            )),
      ],
    );
  }
}
