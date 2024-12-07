import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:live_message/data/model/person.dart';

class AppHeader extends StatelessWidget {
  const AppHeader(
      {super.key, required this.person, required this.onTapProfile});

  final Person person;
  final VoidCallback onTapProfile;

  @override
  Widget build(BuildContext context) {
    print("name : " + person.name.toString());
    return GestureDetector(
      onTap: onTapProfile,
      child: Card(
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/app_logo.png",
                height: 60,
                width: 60,
              ),
              const Gap(16.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(person.name ?? ""),
                  const Gap(8.0),
                  Text(person.socketID ?? ""),
                ],
              ),
              const Spacer(),
              Icon(
                  person.isActive ?? true
                      ? Icons.circle_rounded
                      : Icons.circle_outlined,
                  color: person.isActive ?? true ? Colors.green : Colors.grey)
            ],
          ),
        ),
      ),
    );
  }
}
