import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_chat_fb/app_constant.dart';
import 'package:group_chat_fb/core/enum/enums.dart';
import 'package:group_chat_fb/features/authentication/presentation/bloc/user/bloc/user_bloc.dart';
import 'package:group_chat_fb/features/chat/domain/entity/single_chat_entity.dart';
import 'package:group_chat_fb/features/chat/presentation/bloc/group/group_bloc.dart';
import 'package:group_chat_fb/features/chat/presentation/pages/single_chat_page.dart';
import 'package:group_chat_fb/features/chat/presentation/widgets/search_field.dart';

class GroupPage extends StatefulWidget {
  String uid;
  static const routeName = "group_page";
  GroupPage({Key? key, required this.uid}) : super(key: key);

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  final TextEditingController _groupSearchController = TextEditingController();
  final FocusNode _groupFocusNode = FocusNode();

  @override
  void initState() {
    _groupSearchController.addListener(() {
      setState(() {});
    });
    _groupFocusNode.addListener(() {
      setState(() {});
    });
    BlocProvider.of<GroupBloc>(context).add(GetGroupEvent());
    log("calling..");

    super.initState();
  }

  @override
  void didChangeDependencies() {
    BlocProvider.of<GroupBloc>(context).add(GetGroupEvent());

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    log("disposing...");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(builder: (context, userState) {
      if (userState is UserLoaded) {
        final user = userState.users
            .where((element) => element.userId == widget.uid)
            .first;
        return BlocBuilder<GroupBloc, GroupState>(
            builder: (context, groupState) {
          if (groupState is GroupLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(
                    backgroundColor: AppConstant.PRIMARY_COLOR,
                  ),
                  Text("Loading groups...")
                ],
              ),
            );
          }
          // else if (groupState is GroupJoining) {

          else if (groupState is GroupLoaded) {
            final filterGroup = groupState.groupEntities.where((element) {
              return (element.groupName ?? "")
                      .startsWith(_groupSearchController.text) ||
                  (element.groupName?.toLowerCase() ?? "")
                      .startsWith(_groupSearchController.text.toLowerCase());
            }).toList();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  SearchField(
                    textEditingController: _groupSearchController,
                    focusNode: _groupFocusNode,
                    hintText: "Type group name",
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  filterGroup.isEmpty
                      ? Expanded(
                          child: Container(
                              child:
                                  const Center(child: Text("No group found!"))))
                      : Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: filterGroup.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        BlocProvider.of<GroupBloc>(context).add(
                                            JoinGroupEvent(
                                                groupEntity:
                                                    filterGroup[index]));

                                        Navigator.pushNamed(
                                            context, SingleChatPage.routeName,
                                            arguments: [
                                              SingleChatEntity(
                                                  userName: user.name,
                                                  groupName: filterGroup[index]
                                                      .groupName,
                                                  groupId: filterGroup[index]
                                                      .groupId,
                                                  uid: widget.uid),
                                              MessageType.group
                                            ]);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                width: 0.5,
                                                color: Colors.grey[500]!)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    filterGroup[index]
                                                        .groupName
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    filterGroup[index]
                                                        .lastMessage
                                                        .toString(),
                                                    style: TextStyle(
                                                        color:
                                                            Colors.grey[500]),
                                                  ),
                                                ],
                                              ),
                                              CircleAvatar(
                                                radius: 22,
                                                backgroundImage: NetworkImage(
                                                  filterGroup[index]
                                                          .groupProfileImage ??
                                                      "https://cdn.vectorstock.com/i/1000x1000/45/79/male-avatar-profile-picture-silhouette-light-vector-4684579.webp",
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (index == filterGroup.length - 1) ...{
                                      const SizedBox(
                                        height: 50,
                                      )
                                    }
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text("cannot load group"),
            );
          }
        });
      } else {
        return const Center(
          child: CircularProgressIndicator(
            backgroundColor: AppConstant.PRIMARY_COLOR,
          ),
        );
      }
    });
  }
}
