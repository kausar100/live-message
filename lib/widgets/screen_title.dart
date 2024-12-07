import 'package:flutter/material.dart';

class ScreenTitle extends StatelessWidget {
  const ScreenTitle({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(8.0),
        decoration: const BoxDecoration(color: Colors.white),
        width: MediaQuery.of(context).size.width * 0.8,
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 24.0, letterSpacing: 1.0, fontWeight: FontWeight.bold),
        ));
  }
}
