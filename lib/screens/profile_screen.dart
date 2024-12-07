import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:live_message/data/model/person.dart';
import 'package:live_message/data/provider/room_data_provider.dart';
import 'package:live_message/data/socket_resources/socket_methods.dart';
import 'package:live_message/screens/login_screen.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = "/profile";

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final SocketMethods _socketMethods = SocketMethods();

  @override
  void initState() {
    super.initState();
    _socketMethods.onErrorOccuredListener(context);
  }

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as Person;
    final me = Provider.of<RoomDataProvider>(context).currentUser!;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Card(
                  elevation: 2.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back_ios)),
                        const Text(
                          "Profile",
                          style: TextStyle(
                              letterSpacing: 1.0,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                        if(me.id! == user.id!)
                        IconButton(
                            onPressed: () {
                              //log out
                              _socketMethods.logoutUser(id: user.id!);
                              Navigator.popUntil(context, ModalRoute.withName(LoginScreen.routeName));
                            }, icon: const Icon(Icons.logout))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Card(
                    elevation: 4.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 32,
                            child: Icon(
                              Icons.person,
                              size: 40.0,
                            ),
                          ),
                          const Gap(16.0),
                          Text(
                            user.name.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0),
                          ),
                          const Gap(8.0),
                          Text(
                            user.email.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.black,
                                letterSpacing: 1.0),
                          ),
                        ],
                      ),
                      ),
                    ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
