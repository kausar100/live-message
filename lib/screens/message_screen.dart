import 'package:flutter/material.dart';
import 'package:live_message/data/model/message.dart';
import 'package:live_message/data/model/person.dart';
import 'package:live_message/data/provider/room_data_provider.dart';
import 'package:live_message/data/socket_resources/socket_methods.dart';
import 'package:live_message/screens/profile_screen.dart';
import 'package:live_message/utils/shared.dart';
import 'package:live_message/widgets/message_header.dart';
import 'package:live_message/widgets/message_space.dart';
import 'package:live_message/widgets/single_message.dart';
import 'package:provider/provider.dart';

class MessageScreen extends StatefulWidget {
  static String routeName = '/message';

  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  late final TextEditingController _message;

  final SocketMethods _socketMethods = SocketMethods();

  @override
  void initState() {
    super.initState();
    _message = TextEditingController();
    _socketMethods.onUserBusyListener(context);
    _socketMethods.onErrorOccuredListener(context);
    _socketMethods.onUpdateEngagedSuccessListener(context);
    _socketMethods.onMessageSentSuccessListener(context);
    _socketMethods.onMessageReceiveSuccessListener(context);
  }

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final receiver = ModalRoute.of(context)!.settings.arguments as Person;

    RoomDataProvider roomDataProvider =
        Provider.of<RoomDataProvider>(context, listen: true);

    final messages = roomDataProvider.messages;

    return Scaffold(
        body: Center(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              MessageHeader(
                  person: receiver,
                  onTapProfile: () {
                    Navigator.pushNamed(context, ProfileScreen.routeName,
                        arguments: receiver);
                  },
                  onExitFromRoom: () {
                    //TODO show warning to leave the chat message will be gone
                    //TODO clear the chat mesages, update engaged status
                    //TODO change request user, change active list
                    //TODO need to leave room
                    //TODO notify other i leave
                    Navigator.pop(context);
                  }),
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    final message = messages[index];
                    return SingleMessage(message: message, receiver: receiver);
                  },
                ),
              ),
              MessageSpace(
                  textController: _message,
                  onChooseFile: () {
                    //choose file
                    showSnackBar(context, "This feature is unavailable!");
                  },
                  onSend: () {
                    if (_message.text.isEmpty) {
                      showSnackBar(context, "Empty message");
                    } else {
                      final message = Message(senderID: roomDataProvider.currentUser!.id!, receiver: receiver.id!, text: _message.text.trim());
                      //send message
                      _socketMethods.messageSent(chatId: roomDataProvider.chatID!, message: message);
                      setState(() {
                        _message.clear();
                      });
                    }
                  })
            ],
          ),
        ),
      ),
    ));
  }
}
