import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:live_message/data/model/person.dart';

class SingleUser extends StatelessWidget {
  const SingleUser({super.key, required this.person, required this.onTap});

  final Person person;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 16.0, top: 8.0, right: 8.0, bottom: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 32,
                child: Icon(
                  Icons.person,
                  size: 40.0,
                ),
              ),
              const Gap(16.0),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.blueGrey),
                      borderRadius: BorderRadius.circular(8.0)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(person.name!),
                          const Gap(8.0),
                          Text(person.email!, overflow: TextOverflow.clip),
                        ],
                      ),
                      if (person.isActive!)
                        const Icon(
                          Icons.chat_rounded,
                          color: Colors.blueAccent,
                        )
                      else
                        const Icon(
                          Icons.not_interested,
                          color: Colors.grey,
                        )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
