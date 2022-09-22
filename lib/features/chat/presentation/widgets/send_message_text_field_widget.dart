import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_chat_fb/core/enum/enums.dart';
import 'package:group_chat_fb/core/use_case/usecase.dart';
import 'package:group_chat_fb/features/chat/presentation/bloc/chat/chat_bloc.dart';
import 'package:group_chat_fb/features/chat/presentation/bloc/group/group_bloc.dart';

import '../../domain/entity/group_entity.dart';
import '../../domain/entity/my_chat_entity.dart';
import '../../domain/entity/text_message_entity.dart';
import '../bloc/myChatBloc/my_chat_bloc_bloc.dart';

class SendMessageTextFieldWidget extends StatefulWidget {
  SendMessageTextFieldWidgetParams params;

  SendMessageTextFieldWidget({Key? key, required this.params})
      : super(key: key);

  @override
  State<SendMessageTextFieldWidget> createState() =>
      _SendMessageTextFieldWidgetState();
}

class _SendMessageTextFieldWidgetState
    extends State<SendMessageTextFieldWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(builder: (context, chatState) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10, left: 4, right: 4),
        child: Row(
          children: [
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(80),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.2),
                      offset: const Offset(0.0, 0.50),
                      spreadRadius: 1,
                      blurRadius: 1,
                    )
                  ]),
              child: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.insert_emoticon,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Container(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 60),
                      child: Scrollbar(
                          child: TextField(
                        style: const TextStyle(fontSize: 14),
                        controller: widget.params.messageController,
                        maxLines: null,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Type a message"),
                      )),
                    ),
                  )),
                  Row(
                    children: [
                      const Icon(Icons.link),
                      const SizedBox(
                        width: 10,
                      ),
                      widget.params.messageController.text.isEmpty
                          ? Icon(
                              Icons.camera_alt,
                              color: Colors.grey[500],
                            )
                          : const Text(""),
                    ],
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                ],
              ),
            )),
            const SizedBox(
              width: 5,
            ),
            GestureDetector(
              onTap: () {
                _sendMessage();
              },
              child: Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  widget.params.messageController.text.isEmpty
                      ? Icons.mic
                      : Icons.send,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  void _sendMessage() {
    if (widget.params.messageController.text.isNotEmpty) {
      BlocProvider.of<ChatBloc>(context).add(SendTextMessageEvent(
          channelId: widget.params.channelId,
          textMessageEntity: TextMessageEntity(
              content: widget.params.messageController.text,
              time: Timestamp.now(),
              senderId: widget.params.uid,
              senderName: widget.params.senderName,
              type: "TEXT"),
          messageType: widget.params.messageType));
      BlocProvider.of<MyChatBloc>(context).add(AddToMyChatEvent(
        myChatEntity: MyChatEntity(
            channelId: widget.params.channelId,
            communicationType: "Text",
            recipientUID: widget.params.channelId,
            profileUrl: widget.params.photoUrl,
            recipientName: widget.params.groupName,
            recentTextMessage: widget.params.messageController.text,
            senderUID: widget.params.uid,
            time: Timestamp.now(),
            isGroup: widget.params.messageType == MessageType.group),
      ));

      if (widget.params.messageType == MessageType.group) {
        BlocProvider.of<GroupBloc>(context).add(UpdateGroupEvent(
            groupEntity: GroupEntity(
                groupId: widget.params.channelId,
                creationTime: Timestamp.now(),
                lastMessage: widget.params.messageController.text)));
      } else {
        BlocProvider.of<MyChatBloc>(context)
            .add(GetMyChatEvent(uid: widget.params.uid));
        BlocProvider.of<ChatBloc>(context).add(GetTextMessageEvent(
            channelId: widget.params.uid, messageType: MessageType.oneToOne));
      }
    }
  }
}

class SendMessageTextFieldWidgetParams {
  MessageType messageType;
  String channelId;
  String uid;
  String senderName;
  String photoUrl;

  String groupName;
  TextEditingController messageController;

  SendMessageTextFieldWidgetParams(
      {required this.channelId,
      required this.messageType,
      required this.senderName,
      required this.uid,
      required this.groupName,
      required this.photoUrl,
      required this.messageController});
}




// widget.singleChatEntity.groupId!
//               : widget.channelId != ""
//                   ? widget.channelId
//                   : singleChannelId!,