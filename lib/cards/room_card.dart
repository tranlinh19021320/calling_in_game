import 'package:calling_in_game/utils/utils.dart';
import 'package:flutter/material.dart';

class RoomCard extends StatefulWidget {
  final String roomuid;
  const RoomCard({super.key, required this.roomuid});

  @override
  State<RoomCard> createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: blueColor),
      ),
      child: Center(
        child: Text(widget.roomuid, style:const  TextStyle(color: whiteColor),),
      ),
    );
  }
}