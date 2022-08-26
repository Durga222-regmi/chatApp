import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_chat_fb/app_constant.dart';
import 'package:group_chat_fb/core/dynamic_widgets/custom_app_bar.dart';
import 'package:group_chat_fb/core/dynamic_widgets/custom_loader_widget.dart';
import 'package:group_chat_fb/features/chat/presentation/bloc/group/group_bloc.dart';

class GroupMemberPage extends StatefulWidget {
  static const routeName = "/group_member_page";
  String groupId;

  GroupMemberPage({Key? key, required this.groupId}) : super(key: key);

  @override
  State<GroupMemberPage> createState() => _GroupMemberPageState();
}

class _GroupMemberPageState extends State<GroupMemberPage> {
  @override
  void initState() {
    BlocProvider.of<GroupBloc>(context)
        .add(GetSingleGroupEvent(uid: widget.groupId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupBloc, GroupState>(builder: (context, groupState) {
      if (groupState is GroupLoading) {
        return Center(
          child: CustomLoaderWidget(),
        );
      } else if (groupState is GetSingleGroupStateLoaded) {
        final userList = groupState.groupEntity.users;
        userList!.removeWhere(
            (user) => user.uid == groupState.groupEntity.admin!.uid);
        return Scaffold(
          appBar: CustomAppBar(
            leading: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                  groupState.groupEntity.groupProfileImage ??
                      AppConstant.defaultUrl),
            ),
            title: groupState.groupEntity.groupName,
            extraTitle: [
              Text(
                "${groupState.groupEntity.joinUsers ?? ""} members",
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w100),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          width: 0.5,
                          color: AppConstant.BORDER_COLOR,
                        )),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage(groupState
                                            .groupEntity.admin?.profileUrl ??
                                        AppConstant.defaultUrl),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    groupState.groupEntity.admin?.name ?? "",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const Center(
                                child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(child: Text("Admin")),
                            ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: userList.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final user = userList[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              width: 0.5,
                              color: AppConstant.BORDER_COLOR,
                            )),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage(
                                        user.profileUrl ??
                                            AppConstant.defaultUrl),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    user.name ?? "",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ))
              ],
            ),
          ),
        );
      } else if (groupState is GroupFailure) {
        return Scaffold(
          body: Center(
            child: Text(groupState.failureMessage),
          ),
        );
      } else {
        return Container();
      }
    });
  }
}
