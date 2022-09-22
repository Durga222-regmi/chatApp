import 'dart:async';

import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:group_chat_fb/core/enum/enums.dart';
import 'package:intl/intl.dart';

import '../../domain/entity/text_message_entity.dart';
import 'message_layout_widget.dart';

class MessageListWidget extends StatefulWidget {
  String uid;
  ScrollController messageScrollController;
  List<TextMessageEntity> chatMessages;
  MessageType messageType;
  String channelId;
  MessageListWidget(
      {Key? key,
      required this.chatMessages,
      required this.messageScrollController,
      required this.uid,
      required this.channelId,
      required this.messageType})
      : super(key: key);

  @override
  State<MessageListWidget> createState() => _MessageListWidgetState();
}


class _MessageListWidgetState extends State<MessageListWidget> {
  @override
  Widget build(BuildContext context) {
    Timer(const Duration(milliseconds: 100), () {
      widget.messageScrollController.animateTo(
          widget.messageScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInQuad);
    });
    return Expanded(
        child: ListView.builder(
      controller: widget.messageScrollController,
      itemCount: widget.chatMessages.length,
      itemBuilder: (_, index) {
        final message = widget.chatMessages[index];

        if (message.senderId == widget.uid) {
          return MessageLayoutWidget(
              channelId: widget.channelId,
              messageType: widget.messageType,
              name: "me",
              alignName: TextAlign.end,
              nibColor: Colors.lightGreen[400],
              time: DateFormat('hh:mm a')
                  .format(message.time?.toDate() ?? Timestamp.now().toDate()),
              align: TextAlign.left,
              boxAlign: CrossAxisAlignment.start,
              crossAlign: CrossAxisAlignment.end,
              nip: BubbleNip.rightTop,
              senderUid: message.senderId,
              text: message.content,
              status: message.status,
              type: message.type);
        } else {
          return MessageLayoutWidget(
              messageType: widget.messageType,
              channelId: widget.channelId,
              name: message.senderName ?? "",
              alignName: TextAlign.end,
              nibColor: Colors.white,
              time: DateFormat('hh:mm a')
                  .format(message.time?.toDate() ?? Timestamp.now().toDate()),
              align: TextAlign.left,
              boxAlign: CrossAxisAlignment.start,
              crossAlign: CrossAxisAlignment.start,
              nip: BubbleNip.leftTop,
              text: message.content,
              senderUid: message.senderId,
              status: message.status,
              type: message.type);
        }
      },
    ));
  }
}
