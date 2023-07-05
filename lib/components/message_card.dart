import 'package:flutter/material.dart';
import 'package:wap_clone/components/time_format.dart';
import 'package:wap_clone/models/chat_model.dart';

import '../helper/helper.dart';

class MessageCard extends StatefulWidget {
  final ChatModel message;
  const MessageCard({super.key, required this.message});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return Helper.user.uid == widget.message.fromUID
        ? _senderCard()
        : _recieverCard();
  }

  Widget _recieverCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Text(
            widget.message.msg,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            TimeFormat.getFormattedTime(
                context: context, time: widget.message.sendTime),
            style: const TextStyle(color: Colors.black26, fontSize: 12),
          ),
        )
      ],
    );
  }

  Widget _senderCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          decoration: const BoxDecoration(
              color: Color(0xFFF87A44),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20))),
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Text(
            widget.message.msg,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Text(
            TimeFormat.getFormattedTime(
                context: context, time: widget.message.sendTime),
            style: const TextStyle(color: Colors.black26, fontSize: 12),
          ),
        )
      ],
    );
  }
}
