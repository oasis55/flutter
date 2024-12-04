import 'package:flutter/material.dart';
import 'package:string_to_hex/string_to_hex.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../models/message.dart';

class MessageList extends StatefulWidget {
  const MessageList({
    super.key,
    required this.messageList
  });

  final List<Message> messageList;

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
          reverse: true,
          itemCount: widget.messageList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.messageList[index].userId.substring(0, 8),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(StringToHex.toColor(widget.messageList[index].userId.substring(0, 8)))
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        timeago.format(
                            DateTime.fromMicrosecondsSinceEpoch(int.parse(widget.messageList[index].timestamp))
                        ),
                        style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.black38,
                            fontSize: 13
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.messageList[index].text,
                    style: const TextStyle(fontSize: 16),
                  )
                ],
              ),
            );
          }
      ),
    );
  }
}
