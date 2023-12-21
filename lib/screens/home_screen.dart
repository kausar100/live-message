import 'package:flutter/material.dart';
import 'package:live_message/data/model/person.dart';
import 'package:live_message/data/provider/room_data_provider.dart';
import 'package:live_message/data/socket_resources/socket_methods.dart';
import 'package:live_message/screens/message_screen.dart';
import 'package:live_message/screens/profile_screen.dart';
import 'package:live_message/utils/shared.dart';
import 'package:live_message/widgets/app_header.dart';
import 'package:live_message/widgets/user_list.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool active = false;
  final SocketMethods _socketMethods = SocketMethods();

  @override
  void initState() {
    super.initState();
    _socketMethods.onActiveUserListener(context);
    _socketMethods.onRequestUserListener(context);
    _socketMethods.onErrorOccuredListener(context);
  }

  @override
  Widget build(BuildContext context) {
    RoomDataProvider roomDataProvider = Provider.of<RoomDataProvider>(context);
    final userList = List.generate(
        5,
        (index) => Person("Person${index + 1}", "email", "socketID", "chatID",
            active, !active));

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            active = !active;
          });
        },
        child: const Icon(Icons.sync),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppHeader(
                person: roomDataProvider.currentUser ??
                    Person("name", "email", "socketID", "chatID", true, false),
                onTapProfile: () {
                  Navigator.pushNamed(context, ProfileScreen.routeName,
                      arguments: roomDataProvider.currentUser ??
                          Person("name", "email", "socketID", "chatID", true,
                              false));
                },
              ),
              Expanded(
                flex: 2,
                child: UserList(
                  title: "Request User",
                  activeUsers: userList,
                  onTapUser: (user) {
                    //goto message screen if user is not engaged
                    print(user.name.toString());
                    if (user.isEngaged!) {
                      showSnackBar(context, "User is Busy");
                    } else {
                      Navigator.pushNamed(context, MessageScreen.routeName,
                          arguments: user);
                    }
                  },
                ),
              ),
              Expanded(
                flex: 2,
                child: UserList(
                  title: "Active User",
                  activeUsers: roomDataProvider.userList,
                  onTapUser: (user) {
                    showSnackBar(context, user.name.toString());
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
