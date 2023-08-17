import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key? key,
    required this.isResponse,
    required this.message,
    required this.senderName,
  }) : super(key: key);

  final bool isResponse;
  final String message;
  final String senderName;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment:
            isResponse ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //   child:
                  child:
        Text(
              senderName,
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                //-----------------------
                color: Colors.white,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 12.0,
            ),
            decoration: BoxDecoration(
              color: isResponse ? Colors.green : Colors.white,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: SelectableText(
              message,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
          ),
    ],
      ),
    );
  }
}
