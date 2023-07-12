import 'package:calling_in_game/cards/create_room_dialog.dart';
import 'package:calling_in_game/cards/join_room_dialog.dart';
import 'package:calling_in_game/cards/profile_card.dart';
import 'package:calling_in_game/cards/room_card.dart';
import 'package:calling_in_game/screens/login_screen.dart';
import 'package:calling_in_game/server/firebase_auth.dart';
import 'package:calling_in_game/server/provider.dart';
import 'package:calling_in_game/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final myid = FirebaseAuth.instance.currentUser!.uid;
  List myrooms = [];

  @override
  void initState() {
    super.initState();

    getRooms();
  }

  getRooms() async {
    try {
      var snap =
          await FirebaseFirestore.instance.collection("users").doc(myid).get();
      setState(() {
        myrooms = snap.data()!['rooms'];
      });
      showSnackBar(context, '${myrooms.length}', true);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarGreenColor,
        title: const Text(
          'Voice Chat',
          style: TextStyle(
            fontFamily: 'MoonTime',
            fontWeight: FontWeight.bold,
            color: yellowColor,
            fontSize: 28,
          ),
        ),
        actions: [
          ProfileUser(
            uid: FirebaseAuth.instance.currentUser!.uid,
          ),
          IconButton(
              onPressed: () async {
                await Auth().logOut();
                if (context.mounted) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const LoginScreen()));
                }
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // button add room and join by id
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.center,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          showSnackBar(context, 'ấn tạo', false);
                          showDialog(
                              context: context,
                              builder: (context) =>
                                  const CreateNewRoomDialog());
                        },
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 12),
                            // color: blueColor,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: blueColor),
                            child: const Column(
                              children: [
                                Icon(
                                  Icons.add,
                                  color: whiteColor,
                                ),
                                Text(
                                  "Tạo phòng mới",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                ),
                              ],
                            )),
                      ),
                      InkWell(
                        onTap: () {
                          showSnackBar(context, "ấn tham gia", false);
                          showDialog(
                              context: context,
                              builder: (context) => const JoinRoomDialog());
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 12),
                          // color: blueColor,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: blueColor),

                          child: const Column(
                            children: [
                              Icon(
                                Icons.input_sharp,
                                color: whiteColor,
                              ),
                              Text(
                                "Tham gia bằng id",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                width: double.infinity,
                height: 24,
                color: greenColor,
                child: const Center(child: Text("Phòng của bạn")),
              ),
              const SizedBox(
                height: 12,
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: myrooms.length,
                    itemBuilder: (context, index) => Container(
                          child: Column(
                            children: [
                              RoomCard(
                                roomuid: myrooms[index].toString(),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                            ],
                          ),
                        )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
