import 'dart:async';
import 'dart:developer';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_chat_fb/app_constant.dart';
import 'package:group_chat_fb/core/dynamic_widgets/custom_app_bar.dart';
import 'package:group_chat_fb/core/enum/enums.dart';
import 'package:group_chat_fb/features/authentication/presentation/bloc/user/bloc/user_bloc.dart';
import 'package:group_chat_fb/features/chat/domain/entity/single_chat_entity.dart';
import 'package:group_chat_fb/features/chat/domain/entity/text_message_entity.dart';
import 'package:group_chat_fb/features/chat/presentation/bloc/chat/chat_bloc.dart';
import 'package:group_chat_fb/features/chat/presentation/bloc/myChatBloc/my_chat_bloc_bloc.dart';
import 'package:group_chat_fb/features/chat/presentation/pages/group_member_page.dart';
import 'package:group_chat_fb/features/chat/presentation/widgets/message_list_widget.dart';
import 'package:group_chat_fb/features/chat/presentation/widgets/send_message_text_field_widget.dart';
import 'package:group_chat_fb/page_constant.dart';

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
  UserBloc? userBloc;
  ChatBloc? chatBloc;

  String? singleChannelId;

  @override
  void didChangeDependencies() {
    final chatState = chatBloc!.state;
    if (chatState is ChatChannelCreated) {
      setState(() {
        singleChannelId = chatState.channelID;
      });
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    controllerSettings();
    initializeBloc();
    initializeUserAndMessage();

    super.initState();
  }

  @override
  void dispose() {
    userBloc!.add(UpdateChattingWithEvent(
        uid: widget.singleChatEntity.uid!, users: const []));

    _messageController.dispose();
    _messageScrollController.dispose();

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
            GestureDetector(
                onTap: () {
                  BlocProvider.of<ChatBloc>(context).add(SendTextMessageEvent(
                      channelId: widget.channelId,
                      textMessageEntity: TextMessageEntity(
                        time: Timestamp.now(),
                        type: "VID_CALL",
                        status: "CALLED",
                        senderId: widget.singleChatEntity.uid,
                      ),
                      messageType: widget.messageType));
                  Navigator.pushNamed(context, PageConstant.videoCallingWidget,
                      arguments: [
                        widget.messageType == MessageType.oneToOne
                            ? widget.channelId
                            : widget.singleChatEntity.groupId,
                        widget.messageType,
                        ClientRole.Broadcaster,
                      ]);
                },
                child: const Icon(Icons.video_call_outlined)),
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
                        }),
                    PopupMenuItem(
                      child: const Text("Leave group"),
                      onTap: () {},
                    ),
                  ];
                },
              )
            },
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        body: BlocBuilder<ChatBloc, ChatState>(builder: (context, chatState) {
          log("channel state iss+${chatBloc!.state}");

          if (chatState is ChatChannelCreated) {
            if (widget.messageType == MessageType.oneToOne) {
              chatBloc!.add(GetTextMessageEvent(
                  channelId: singleChannelId!,
                  messageType: widget.messageType));
            }
          } else {}

          if (chatState is ChatLoaded) {
            log("chat loaded..");
            return Column(
              children: [
                MessageListWidget(
                  chatMessages: chatState.textMessages,
                  messageScrollController: _messageScrollController,
                  uid: widget.singleChatEntity.uid!,
                  channelId: widget.messageType == MessageType.group
                      ? widget.singleChatEntity.groupId!
                      : widget.channelId,
                  messageType: widget.messageType,
                ),
                SendMessageTextFieldWidget(
                    params: SendMessageTextFieldWidgetParams(
                  messageController: _messageController,
                  channelId: widget.messageType == MessageType.group
                      ? widget.singleChatEntity.groupId!
                      : widget.channelId != ""
                          ? widget.channelId
                          : singleChannelId!,
                  groupName: widget.singleChatEntity.groupName!,
                  messageType: widget.messageType,
                  photoUrl: widget.singleChatEntity.photoUrl ??
                      AppConstant.defaultUrl,
                  senderName: widget.singleChatEntity.userName ?? "",
                  uid: widget.singleChatEntity.uid!,
                ))
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

  initializeBloc() {
    chatBloc = BlocProvider.of<ChatBloc>(context);

    userBloc = BlocProvider.of<UserBloc>(context);
  }

  void initializeUserAndMessage() {
    if (widget.messageType == MessageType.group) {
      chatBloc!.add(GetTextMessageEvent(
          channelId: widget.singleChatEntity.groupId!,
          messageType: MessageType.group));
    }
    if (widget.channelId != "") {
      chatBloc!.add(GetTextMessageEvent(
          channelId: widget.channelId, messageType: widget.messageType));
    }

    userBloc!.add(UpdateChattingWithEvent(
        uid: widget.singleChatEntity.uid!,
        users: widget.messageType == MessageType.group
            ? widget.singleChatEntity.userList!
            : [widget.singleChatEntity.groupId!]));
  }

  void controllerSettings() {
    _messageController.addListener(() {
      setState(() {});
    });
  }
}
