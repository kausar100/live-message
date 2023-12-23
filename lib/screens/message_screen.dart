import 'package:flutter/material.dart';
import 'package:live_message/data/model/person.dart';
import 'package:live_message/data/provider/room_data_provider.dart';
import 'package:live_message/data/socket_resources/socket_methods.dart';
import 'package:live_message/screens/profile_screen.dart';
import 'package:live_message/utils/shared.dart';
import 'package:live_message/widgets/message_header.dart';
import 'package:live_message/widgets/message_space.dart';
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
  }

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final receiver = ModalRoute.of(context)!.settings.arguments as Person;

    RoomDataProvider roomDataProvider = Provider.of<RoomDataProvider>(context);

    final me = roomDataProvider.currentUser!;

    final screen = MediaQuery.of(context).size;

    return Scaffold(
        body: Center(
      child: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (me.isEngaged == true)
              Padding(
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
                          //TODO need to leave room
                          roomDataProvider.updatedEngagedStatus();
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
            // if (me.isEngaged == false)
            //   Card(
            //     child: Container(
            //         padding: const EdgeInsets.symmetric(
            //             horizontal: 16.0, vertical: 8.0),
            //         height: screen.height * 0.3,
            //         width: screen.width * 0.7,
            //         child: const Center(
            //           child: Text(
            //             "Waiting for accepting request...",
            //             textAlign: TextAlign.center,
            //             style: TextStyle(
            //               fontSize: 24.0,
            //                 color: Colors.black, letterSpacing: 1.0),
            //           ),
            //         )),
            //   )
          ],
        ),
      ),
    ));
  }
}
