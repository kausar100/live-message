import 'package:flutter/material.dart';
import 'package:live_message/data/model/person.dart';
import 'package:live_message/widgets/single_user.dart';

class UserList extends StatelessWidget {
  const UserList({super.key, required this.activeUsers, required this.onTapUser});

  final List<Person> activeUsers;
  final Function(Person) onTapUser;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
          elevation: 4.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ListView.builder(
              itemCount: activeUsers.length,
                          itemBuilder: (context, index) =>
              SingleUser(person: activeUsers[index], onTap: () {
                onTapUser(activeUsers[index]);
              }),
                        ),
          ),
        ));
  }
}
