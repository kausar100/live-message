import 'package:flutter/material.dart';
import 'package:live_message/data/model/person.dart';

class MessageHeader extends StatelessWidget {
  const MessageHeader(
      {super.key,
      required this.person,
      required this.onTapProfile,
      required this.onExitFromRoom});

  final Person person;
  final VoidCallback onTapProfile;
  final VoidCallback onExitFromRoom;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
            onPressed:onExitFromRoom,
          icon: const Icon(Icons.arrow_back_ios)),
            Text(
              person.name!,
              style: const TextStyle(fontSize: 18),
            ),
            GestureDetector(
              onTap: onTapProfile,
              child: const CircleAvatar(
                radius: 24,
                child: Icon(
                  Icons.person,
                  size: 40.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
