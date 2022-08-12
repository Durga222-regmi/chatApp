import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_chat_fb/app_constant.dart';
import 'package:group_chat_fb/features/authentication/presentation/bloc/user/bloc/user_bloc.dart';
import 'package:group_chat_fb/features/chat/domain/entity/engage_user_entity.dart';
import 'package:group_chat_fb/features/chat/presentation/bloc/chat/chat_bloc.dart';
import 'package:group_chat_fb/features/chat/presentation/pages/single_chat_page.dart';
import 'package:group_chat_fb/features/chat/presentation/widgets/search_field.dart';

import '../../../../core/enum/enums.dart';
import '../../domain/entity/single_chat_entity.dart';

class AllUserPage extends StatefulWidget {
  static const routeName = "/all_user_page";
  final String? uid;

  const AllUserPage({Key? key, required this.uid}) : super(key: key);

  @override
  State<AllUserPage> createState() => _AllUserPageState();
}

class _AllUserPageState extends State<AllUserPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  @override
  void initState() {
    _searchController.addListener(() {
      setState(() {});
    });
    _searchFocus.addListener(() {
      setState(() {});
    });
    BlocProvider.of<UserBloc>(context).add(GetUserEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(builder: (context, userState) {
      if (userState is UserLoaded) {
        final user = userState.users
            .where((element) => element.userId != widget.uid)
            .toList();

        final filterUsers = user.where((element) {
          return (element.name ?? "").startsWith(_searchController.text) ||
              (element.name?.toLowerCase() ?? "")
                  .startsWith(_searchController.text.toLowerCase());
        }).toList();

        log(filterUsers.length.toString());
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              SearchField(
                textEditingController: _searchController,
                focusNode: _searchFocus,
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                  child: filterUsers.isEmpty
                      ? const Center(
                          child: Text("No users found!"),
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: filterUsers.length,
                          itemBuilder: (ctx, index) {
                            return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: BlocBuilder<ChatBloc, ChatState>(
                                    builder: (context, chatState) {
                                  return GestureDetector(
                                    onTap: () async {
                                      BlocProvider.of<ChatBloc>(context).add(
                                          CreateOneToOneChannelEvent(
                                              engageUserEntity:
                                                  EngageUserEntity(
                                                      otherUid:
                                                          filterUsers[index]
                                                              .userId,
                                                      uid: widget.uid)));
                                      Navigator.pushNamed(
                                          context, SingleChatPage.routeName,
                                          arguments: [
                                            SingleChatEntity(
                                                groupName:
                                                    filterUsers[index].name,
                                                uid: widget.uid,
                                                groupId:
                                                    filterUsers[index].userId),
                                            MessageType.oneToOne
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
                                                  filterUsers[index]
                                                      .name
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
                                                  filterUsers[index]
                                                      .email
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.grey[500]),
                                                ),
                                              ],
                                            ),
                                            CircleAvatar(
                                              radius: 22,
                                              backgroundImage: NetworkImage(
                                                filterUsers[index].profileUrl ??
                                                    "https://cdn.vectorstock.com/i/1000x1000/45/79/male-avatar-profile-picture-silhouette-light-vector-4684579.webp",
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }));
                          }))
            ],
          ),
        );
      }
      return const Center(
        child: CircularProgressIndicator(
          backgroundColor: AppConstant.PRIMARY_COLOR,
        ),
      );
    });
  }
}
