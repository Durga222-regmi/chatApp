import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_chat_fb/app_constant.dart';
import 'package:group_chat_fb/core/dynamic_widgets/custom_chat_tile_widget.dart';
import 'package:group_chat_fb/core/dynamic_widgets/custom_loader_widget.dart';
import 'package:group_chat_fb/features/chat/presentation/bloc/chat/chat_bloc.dart';
import 'package:group_chat_fb/features/chat/presentation/bloc/myChatBloc/my_chat_bloc_bloc.dart';
import 'package:group_chat_fb/features/chat/presentation/pages/single_chat_page.dart';

import '../../../../core/enum/enums.dart';
import '../../domain/entity/single_chat_entity.dart';

class MyChatPage extends StatefulWidget {
  String uid;
  static const String routeName = "/my_chat_page";

  MyChatPage({Key? key, required this.uid}) : super(key: key);

  @override
  State<MyChatPage> createState() => _MyChatPageState();
}

class _MyChatPageState extends State<MyChatPage> {
  @override
  void initState() {
    BlocProvider.of<MyChatBloc>(context).add(GetMyChatEvent(uid: widget.uid));
    log(BlocProvider.of<MyChatBloc>(context).state.toString());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    BlocProvider.of<MyChatBloc>(context).add(GetMyChatEvent(uid: widget.uid));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MyChatBloc, MyChatBlocState>(
          builder: (context, chatState) {
        if (chatState is MyChatsLoading) {
          return CustomLoaderWidget(
            message: "loading chats...",
          );
        } else if (chatState is MyChatLoaded) {
          if (chatState.myChatEntities.isEmpty) {
            return const Center(
              child: Text("Chat list is empty..."),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ListView.builder(
              itemCount: chatState.myChatEntities.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemBuilder: (BuildContext context, int index) {
                final myChat = chatState.myChatEntities[index];
                return CustomChatTile(
                  lastMessage: myChat.recentTextMessage,
                  messageType: myChat.isGroup!
                      ? MessageType.group
                      : MessageType.oneToOne,
                  name: myChat.recipientName,
                  onTap: () {
                    log(myChat.isGroup.toString());
                    Navigator.pushNamed(context, SingleChatPage.routeName,
                        arguments: [
                          SingleChatEntity(
                              userName: myChat.senderName,
                              groupName: myChat.recipientName,
                              groupId: myChat.recipientUID,
                              uid: widget.uid,
                              photoUrl: myChat.profileUrl),
                          myChat.isGroup!
                              ? MessageType.group
                              : MessageType.oneToOne,
                          myChat.channelId
                        ]).then((value) {
                      BlocProvider.of<MyChatBloc>(context)
                          .add(GetMyChatEvent(uid: widget.uid));
                      log("returning...");
                      setState(() {});
                    });
                  },
                  profileUrl: myChat.profileUrl ?? AppConstant.defaultUrl,
                );
              },
            ),
          );
        } else {
          return const Center(
            child: Text("This isat page"),
          );
        }
      }),
    );
  }
}
