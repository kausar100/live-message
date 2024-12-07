import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final bool enableBorder;
  final bool showLoading;

  const CustomButton(
      {super.key,
      required this.text,
      required this.onTap,
      this.enableBorder = true,
      this.showLoading = false});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: enableBorder
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(color: Colors.grey),
            )
          : null,
      child: TextButton(
        style: TextButton.styleFrom(
            minimumSize: Size(size.width * 0.7, 60.0),
            textStyle: const TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                letterSpacing: 1.0,
                fontWeight: FontWeight.bold)),
        onPressed: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(text),
            const SizedBox(width: 8.0),
            showLoading
                ? const SizedBox(
                    height: 24.0,
                    width: 24.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 3.0,
                    ))
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
