import 'package:flutter/material.dart';
import 'package:live_message/data/model/person.dart';
import 'package:live_message/screens/profile_screen.dart';
import 'package:live_message/utils/shared.dart';
import 'package:live_message/widgets/app_header.dart';
import 'package:live_message/widgets/message_header.dart';
import 'package:live_message/widgets/message_space.dart';

class MessageScreen extends StatefulWidget {
  static String routeName = '/message';

  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  late final TextEditingController _message;

  @override
  void initState() {
    super.initState();
    _message = TextEditingController();
  }

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as Person;

    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              MessageHeader(
                  person: user,
                  onTapProfile: () {
                    Navigator.pushNamed(context, ProfileScreen.routeName,
                        arguments: user);
                  },
                  onExitFromRoom: () {
                    //need to leave room
                    Navigator.pop(context);
                  }),
              Expanded(
                child: Card(
                  child: ListView.builder(
                    itemCount: 20,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("this is message number $index"),
                    ),
                  ),
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
                      //send message
                      print(_message.text);
                      _message.clear();
                    }
                  })
            ],
          ),
        ),
      ),
    ));
  }
}
