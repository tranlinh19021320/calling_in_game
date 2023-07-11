import 'package:flutter/material.dart';

// Colors
const Color backgroundColor = Color.fromARGB(121, 52, 58, 45);
const Color blackColor = Color.fromARGB(1, 1, 1, 1);
const Color whiteColor = Colors.white;
const Color redColor = Colors.red;
const Color greenColor = Colors.green;
const Color blueColor = Colors.blue;
Color greyColor = Colors.grey.shade200;

//state values
const int IS_DEFAULT_ACCOUNT = 0;
const int IS_CORRECT_ACCOUNT = 1;
const int IS_ERROR_ACCOUNT = 2;

//images
List avatarPath = [
  'assets/avatar_1.jpg',
  'assets/avatar_2.jpg',
  'assets/avatar_3.jpg',
  'assets/avatar_4.jpg',
  'assets/avatar_5.jpg',
  'assets/avatar_6.jpg',
  'assets/avatar_7.jpg',
  'assets/avatar_8.jpg',
  'assets/avatar_9.jpg',
  'assets/avatar_10.jpg',
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
