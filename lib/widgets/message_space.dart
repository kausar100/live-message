import 'package:flutter/material.dart';
import 'package:live_message/widgets/app_textfield.dart';

class MessageSpace extends StatelessWidget {
  const MessageSpace(
      {super.key,
      required this.textController,
      required this.onChooseFile,
      required this.onSend});

  final TextEditingController textController;
  final VoidCallback onChooseFile;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 1.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //choose file
            IconButton(
                onPressed: onChooseFile, icon: const Icon(Icons.file_present)),
            //message box
            Expanded(
              child: TextFormField(
                  controller: textController,
                  decoration: InputDecoration(
                    hintText: "Enter you're message...",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                  ),
                  minLines: 1,
                  maxLines: 10,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text),
            ),
            //send icon
            IconButton(onPressed: (){
              FocusManager.instance.primaryFocus?.unfocus();
              onSend();
            }, icon: const Icon(Icons.send_rounded))
          ],
        ),
      ),
    );
  }
}
