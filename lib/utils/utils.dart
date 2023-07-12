import 'dart:math';

import 'package:flutter/material.dart';

// Colors
const Color backgroundColor = Color.fromARGB(121, 52, 58, 45);
const Color blackColor = Color.fromARGB(1, 1, 1, 1);
const Color whiteColor = Colors.white;
const Color redColor = Colors.red;
const Color greenColor = Colors.green;
const Color blueColor = Colors.blue;
Color greyColor = Colors.grey.shade200;
const Color appBarGreenColor = Color.fromARGB(201, 161, 222, 124);
const Color yellowColor = Colors.yellow;

//state values
const int IS_DEFAULT = 0;
const int IS_CORRECT = 1;
const int IS_ERROR = 2;

//images
List avatarPath = [
  'assets/images/avatar_1.jpg',
  'assets/images/avatar_2.jpg',
  'assets/images/avatar_3.jpg',
  'assets/images/avatar_4.jpg',
  'assets/images/avatar_5.jpg',
  'assets/images/avatar_6.jpg',
  'assets/images/avatar_7.jpg',
  'assets/images/avatar_8.jpg',
  'assets/images/avatar_9.jpg',
  'assets/images/avatar_10.jpg',
];
//function
showSnackBar(BuildContext context, String content, bool isError) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: isError ? Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.warning, color: redColor,),
          Text(" $content", style: const TextStyle(color: redColor),)
        ],

      ) : Row (children: [
        const Icon(Icons.check_circle, color: greenColor,),
        Text(" $content", style: const TextStyle(color: greenColor),)
      ]),
  ));
}

bool isValidEmail(String email) {
  return RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(email);
}

int randomId() {
  return Random().nextInt(90) + 10;
}




