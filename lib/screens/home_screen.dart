import 'package:flutter/material.dart';
import 'package:live_message/data/provider/room_data_provider.dart';
import 'package:live_message/data/socket_resources/socket_methods.dart';
import 'package:live_message/screens/message_screen.dart';
import 'package:live_message/screens/profile_screen.dart';
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
    _socketMethods.onUserBusyListener(context);
    _socketMethods.onRequestSentSuccessListener(context);
    _socketMethods.onRequestAcceptSuccessListener(context);
    _socketMethods.onNewLoginUserListener(context);
    _socketMethods.onUpdateEngagedSuccessListener(context);
    _socketMethods.onLogoutSuccessListener(context);
  }

  @override
  Widget build(BuildContext context) {
    RoomDataProvider roomDataProvider = Provider.of<RoomDataProvider>(context, listen: true);

    final user = roomDataProvider.currentUser!;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(user.name.toString()),
              Icon(
                user.isActive ?? true
                    ? Icons.circle_rounded
                    : Icons.circle_outlined,
                color: user.isActive ?? true ? Colors.green : Colors.grey,
                size: 8.0,
              )
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, ProfileScreen.routeName,
                        arguments: roomDataProvider.currentUser);
                  },
                  icon: const Icon(Icons.person)),
            ),
          ],
          leading: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Image.asset(
              "assets/images/app_logo.png",
              height: 60,
              width: 60,
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "Request User",
              ),
              Tab(
                text: "Active User",
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TabBarView(
            children: [
              UserList(
                activeUsers: roomDataProvider.requestedUserList,
                onTapUser: (sender) {
                  //goto message screen if user is not engaged
                  _socketMethods.requestAccept(
                      senderId: sender.id!,
                      receiverId: user.id!,
                      chatId: roomDataProvider.chatID!);

                  //change engaged status
                  _socketMethods.updateEngagedStatus(id: user.id!);

                  // goto next screen
                  Navigator.pushNamed(context, MessageScreen.routeName,
                      arguments: sender);
                },
              ),
              UserList(
                activeUsers: roomDataProvider.userList,
                onTapUser: (receiver) {
                  //sent a request
                  _socketMethods.requestSent(
                      context: context, senderId: user.id!, receiver: receiver);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
