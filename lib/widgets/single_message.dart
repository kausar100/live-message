import 'package:flutter/material.dart';
import 'package:live_message/data/model/message.dart';
import 'package:live_message/data/model/person.dart';
import 'package:live_message/data/provider/room_data_provider.dart';
import 'package:provider/provider.dart';

class SingleMessage extends StatelessWidget {
  const SingleMessage(
      {super.key, required this.message, required this.receiver});

  final Message message;
  final Person receiver;

  @override
  Widget build(BuildContext context) {
    final me = context.read<RoomDataProvider>().currentUser!;
    final sendByMe = message.senderID! == me.id!;
    return Container(
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: sendByMe? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Visibility(
              visible: !sendByMe,
              child: const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  child: Icon(Icons.person),
                ),
              )),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: sendByMe? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 4.0),
                child:
                Text(sendByMe ? me.name.toString() : receiver.name.toString()),
              ),
              Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: sendByMe ? Colors.blueAccent : Colors.greenAccent,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                            color: sendByMe
                                ? Colors.blueAccent
                                : Colors.greenAccent,
                            spreadRadius: 4.0)
                      ]),
                  child: Text(message.text.toString())),
              Container(
                margin: const EdgeInsets.only(top: 4.0),
                child: Text(message.createdAt.toString()),
              ),
            ],
          ),
          Visibility(
              visible: sendByMe,
              child: const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: CircleAvatar(
                  child: Icon(Icons.person),
                ),
              ))
        ],
      ),
    );
  }
}
