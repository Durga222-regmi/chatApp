import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_chat_fb/app_constant.dart';
import 'package:group_chat_fb/core/dynamic_widgets/custom_chat_tile_widget.dart';
import 'package:group_chat_fb/core/enum/enums.dart';
import 'package:group_chat_fb/features/authentication/presentation/bloc/user/bloc/user_bloc.dart';
import 'package:group_chat_fb/features/chat/domain/entity/single_chat_entity.dart';
import 'package:group_chat_fb/features/chat/presentation/bloc/group/group_bloc.dart';
import 'package:group_chat_fb/features/chat/presentation/pages/single_chat_page.dart';
import 'package:group_chat_fb/features/chat/presentation/widgets/search_field.dart';

class GroupPage extends StatefulWidget {
  String uid;
  static const routeName = "/group_page";
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

    super.initState();
  }

  @override
  void dispose() {
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
                              final group = filterGroup[index];
                              return CustomChatTile(
                                messageType: MessageType.group,
                                name: group.groupName,
                                onTap: () {
                                  List<String> usersId = [];
                                  filterGroup[index].users?.forEach((element) {
                                    if (element.uid != widget.uid) {
                                      usersId.add(element.uid!);
                                    } else {
                                      return;
                                    }
                                  });

                                  if (widget.uid !=
                                      filterGroup[index].admin!.uid) {
                                    BlocProvider.of<GroupBloc>(context).add(
                                        JoinGroupEvent(
                                            groupEntity: filterGroup[index],
                                            uid: widget.uid));
                                  }

                                  Navigator.pushNamed(
                                      context, SingleChatPage.routeName,
                                      arguments: [
                                        SingleChatEntity(
                                          userName: user.name,
                                          groupName:
                                              filterGroup[index].groupName,
                                          groupId: filterGroup[index].groupId,
                                          uid: widget.uid,
                                          photoUrl: filterGroup[index]
                                              .groupProfileImage,
                                          userList: usersId,
                                        ),
                                        MessageType.group
                                      ]);
                                },
                                profileUrl: group.groupProfileImage,
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
