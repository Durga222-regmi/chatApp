import 'dart:async';
import 'dart:developer';

import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_chat_fb/app_constant.dart';
import 'package:group_chat_fb/core/dynamic_widgets/custom_app_bar.dart';
import 'package:group_chat_fb/core/enum/enums.dart';
import 'package:group_chat_fb/features/authentication/presentation/bloc/auth/bloc/auth_bloc.dart';
import 'package:group_chat_fb/features/chat/domain/entity/group_entity.dart';
import 'package:group_chat_fb/features/chat/domain/entity/my_chat_entity.dart';
import 'package:group_chat_fb/features/chat/domain/entity/single_chat_entity.dart';
import 'package:group_chat_fb/features/chat/domain/entity/text_message_entity.dart';
import 'package:group_chat_fb/features/chat/presentation/bloc/chat/chat_bloc.dart';
import 'package:group_chat_fb/features/chat/presentation/bloc/group/group_bloc.dart';
import 'package:group_chat_fb/features/chat/presentation/bloc/myChatBloc/my_chat_bloc_bloc.dart';
import 'package:group_chat_fb/features/chat/presentation/pages/group_member_page.dart';
import 'package:intl/intl.dart';

class SingleChatPage extends StatefulWidget {
  SingleChatEntity singleChatEntity;
  MessageType messageType;
  String channelId;

  static const routeName = "/single_chat_page";

  SingleChatPage(
      {Key? key,
      required this.singleChatEntity,
      required this.messageType,
      required this.channelId})
      : super(key: key);

  @override
  State<SingleChatPage> createState() => _SingleChatPageState();
}

class _SingleChatPageState extends State<SingleChatPage> {
  String messageContent = "";
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _messageScrollController = ScrollController();
  final bool _changeKeyBoardType = false;
  final int _menuIndex = 0;

  String? singleChannelId;

  @override
  void initState() {
    _messageController.addListener(() {
      setState(() {});
    });

    if (widget.messageType == MessageType.group) {
      BlocProvider.of<ChatBloc>(context).add(GetTextMessageEvent(
          channelId: widget.singleChatEntity.groupId!,
          messageType: MessageType.group));
    }
    if (widget.channelId != "") {
      BlocProvider.of<ChatBloc>(context).add(GetTextMessageEvent(
          channelId: widget.channelId, messageType: widget.messageType));
    }

    BlocProvider.of<AuthBloc>(context).add(UpdateChattingWithEvent(
        uid: widget.singleChatEntity.uid!,
        users: widget.messageType == MessageType.group
            ? widget.singleChatEntity.userList!
            : [widget.singleChatEntity.groupId!]));

    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messageScrollController.dispose();
    BlocProvider.of<AuthBloc>(context).add(UpdateChattingWithEvent(
        uid: widget.singleChatEntity.uid!, users: const []));

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<MyChatBloc>(context)
            .add(GetMyChatEvent(uid: widget.singleChatEntity.uid!));
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: widget.singleChatEntity.groupName,
          leading: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_outlined,
                ),
              ),
              ClipOval(
                child: SizedBox(
                    height: 20,
                    child: Image.network(widget.singleChatEntity.photoUrl ??
                        AppConstant.defaultUrl)),
              )
            ],
          ),
          actionWidgets: [
            const SizedBox(
              width: 20,
            ),
            const Icon(Icons.video_call_outlined),
            const SizedBox(
              width: 10,
            ),

            if (widget.messageType == MessageType.group) ...{
              PopupMenuButton<MenuItem>(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                        child: const Text("Members"),
                        onTap: () async {
                          await Future.delayed(
                              const Duration(milliseconds: 10));

                          Navigator.pushNamed(
                              context, GroupMemberPage.routeName,
                              arguments: widget.singleChatEntity.groupId);

                          log("going...");
                        }),
                    PopupMenuItem(
                      child: const Text("Leave group"),
                      onTap: () {},
                    ),
                  ];
                },
              )
            },

            // GestureDetector(

            //     onTap: () {
            //       pop
            //       showDialog(
            //           context: context,
            //           builder: (ctx) {
            //             return ActionWidgetForSingleChat(
            //               messageType: widget.messageType,
            //               chatName: widget.singleChatEntity.groupName!,
            //               profileUrl: widget.singleChatEntity.photoUrl ??
            //                   AppConstant.defaultUrl,
            //             );
            //           });
            //     },
            //     child: const Icon(Icons.more_vert_outlined)),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        body: BlocBuilder<ChatBloc, ChatState>(builder: (context, chatState) {
          if (chatState is ChatChannelCreated) {
            if (widget.messageType == MessageType.oneToOne) {
              singleChannelId = chatState.channelID;

              BlocProvider.of<ChatBloc>(context).add(GetTextMessageEvent(
                  channelId: singleChannelId!,
                  messageType: widget.messageType));
            }
          }

          if (chatState is ChatLoaded) {
            return Column(
              children: [
                _messageListWidget(chatState.textMessages),
                _sendMessageTextField(),
              ],
            );
          } else if (chatState is ChatFailure) {
            return Center(
              child: Text(chatState.failureMessage),
            );
          } else if (chatState is ChatLoading ||
              chatState is ChatChannelCreated ||
              chatState is ChatInitial) {
            return const Center(
              child: Text(
                "",
                style: TextStyle(color: AppConstant.BORDER_COLOR),
              ),
            );
          } else {
            return const Center(
              child: Text("can't load the message"),
            );
          }
        }),
      ),
    );
  }

  Expanded _messageListWidget(List<TextMessageEntity> chatMessages) {
    Timer(const Duration(milliseconds: 100), () {
      _messageScrollController.animateTo(
          _messageScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInQuad);
    });
    return Expanded(
        child: ListView.builder(
      controller: _messageScrollController,
      itemCount: chatMessages.length,
      itemBuilder: (_, index) {
        final message = chatMessages[index];

        if (message.senderId == widget.singleChatEntity.uid) {
          return _messageLayOut(
              name: "me",
              alignName: TextAlign.end,
              nibColor: Colors.lightGreen[400],
              time: DateFormat('hh:mm a').format(message.time!.toDate()),
              align: TextAlign.left,
              boxAlign: CrossAxisAlignment.start,
              crossAlign: CrossAxisAlignment.end,
              nip: BubbleNip.rightTop,
              text: message.content);
        } else {
          return _messageLayOut(
              name: message.senderName!,
              alignName: TextAlign.end,
              nibColor: Colors.white,
              time: DateFormat('hh:mm a').format(message.time!.toDate()),
              align: TextAlign.left,
              boxAlign: CrossAxisAlignment.start,
              crossAlign: CrossAxisAlignment.start,
              nip: BubbleNip.leftTop,
              text: message.content);
        }
      },
    ));
  }

  BlocBuilder _sendMessageTextField() {
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
                        controller: _messageController,
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
                      _messageController.text.isEmpty
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
                if (_messageController.text.isNotEmpty) {
                  BlocProvider.of<ChatBloc>(context).add(SendTextMessageEvent(
                      channelId: widget.messageType == MessageType.group
                          ? widget.singleChatEntity.groupId!
                          : widget.channelId != ""
                              ? widget.channelId
                              : singleChannelId!,
                      textMessageEntity: TextMessageEntity(
                          content: _messageController.text,
                          time: Timestamp.now(),
                          senderId: widget.singleChatEntity.uid,
                          senderName: widget.singleChatEntity.userName,
                          type: "TEXT"),
                      messageType: widget.messageType));
                  BlocProvider.of<MyChatBloc>(context).add(AddToMyChatEvent(
                    myChatEntity: MyChatEntity(
                        channelId: widget.channelId != ""
                            ? widget.channelId
                            : singleChannelId ??
                                widget.singleChatEntity.groupId,
                        communicationType: "Text",
                        recipientUID: widget.singleChatEntity.groupId,
                        profileUrl: widget.singleChatEntity.photoUrl,
                        recipientName: widget.singleChatEntity.groupName,
                        recentTextMessage: _messageController.text,
                        senderUID: widget.singleChatEntity.uid,
                        time: Timestamp.now(),
                        isGroup: widget.messageType == MessageType.group),
                  ));

                  if (widget.messageType == MessageType.group) {
                    BlocProvider.of<GroupBloc>(context).add(UpdateGroupEvent(
                        groupEntity: GroupEntity(
                            groupId: widget.singleChatEntity.groupId,
                            creationTime: Timestamp.now(),
                            lastMessage: _messageController.text)));
                  } else {
                    BlocProvider.of<MyChatBloc>(context)
                        .add(GetMyChatEvent(uid: widget.singleChatEntity.uid!));
                    BlocProvider.of<ChatBloc>(context).add(GetTextMessageEvent(
                        channelId: widget.channelId != ""
                            ? widget.channelId
                            : singleChannelId!,
                        messageType: MessageType.oneToOne));
                  }

                  setState(() {
                    _messageController.clear();
                  });
                }
              },
              child: Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  _messageController.text.isEmpty ? Icons.mic : Icons.send,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  Widget _messageLayOut(
      {required String name,
      required TextAlign alignName,
      Color? nibColor,
      required String time,
      required TextAlign align,
      required CrossAxisAlignment boxAlign,
      required CrossAxisAlignment crossAlign,
      required BubbleNip nip,
      String? text}) {
    return Column(
      crossAxisAlignment: crossAlign,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.90,
          ),
          child: Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(3),
            child: Bubble(
              color: nibColor,
              nip: nip,
              child: Column(
                crossAxisAlignment: crossAlign,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    text!,
                    textAlign: align,
                    style: const TextStyle(fontSize: 12, color: Colors.black),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
