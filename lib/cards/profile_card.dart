import 'package:calling_in_game/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileUser extends StatefulWidget {
  final uid;
  const ProfileUser({super.key, required this.uid});

  @override
  State<ProfileUser> createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {

  @override
  Widget build(BuildContext context) {
    return  InkWell(
          onTap: () {
            
          },
          child: Center(
            child: FutureBuilder(
              future: FirebaseFirestore.instance.collection('users').doc(widget.uid).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              
                return Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: backgroundColor,
                      backgroundImage: AssetImage(avatarPath.elementAt((snapshot.data! as dynamic)['avatarIndex'])),
          
                    ),
                    Text('  ' + (snapshot.data! as dynamic)['username'], style: const  TextStyle(color: whiteColor),)
          
                  ],
                );
              }
              ),
          ),
        );
  }
}