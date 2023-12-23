import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

void showWaitingDialog(
    BuildContext context, String text, Function(BuildContext context) onConfirm) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(Icons.cloud_queue, size: 40.0,),
          iconColor: Colors.blueGrey,
          title: Text(
            text,
            style: const TextStyle(color: Colors.black, letterSpacing: 1.0),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
              ),
            ),
            TextButton(
              onPressed: () {
                onConfirm(context);
              },
              child: const Text(
                'Ok',
              ),
            ),
          ],
        );
      });
}

void showProgressDialog(BuildContext context, String text) {
  showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(Icons.cloud_queue, size: 40.0,),
          iconColor: Colors.blueGrey,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                text,
                style: const TextStyle(color: Colors.black, letterSpacing: 1.0),
              ),
              const Gap(24.0),
              const CircularProgressIndicator()
            ],
          ),
        );
      });
}
