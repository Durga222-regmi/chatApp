import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_chat_fb/app_constant.dart';
import 'package:group_chat_fb/core/dynamic_widgets/custom_app_bar.dart';
import 'package:group_chat_fb/features/authentication/presentation/bloc/auth/bloc/auth_bloc.dart';
import 'package:group_chat_fb/features/authentication/presentation/bloc/user/bloc/user_bloc.dart';
import 'package:group_chat_fb/features/authentication/presentation/pages/sing_in_page.dart';
import 'package:group_chat_fb/features/chat/presentation/bloc/group/group_bloc.dart';
import 'package:group_chat_fb/features/chat/presentation/pages/all_user_page.dart';
import 'package:group_chat_fb/features/chat/presentation/pages/create_group_page.dart';
import 'package:group_chat_fb/features/chat/presentation/pages/group_page.dart';
import 'package:group_chat_fb/features/chat/presentation/pages/profile_page.dart';

class ChatHomePage extends StatefulWidget {
  final String uid;
  static const routeName = "/chat_home_page";
  const ChatHomePage({Key? key, required this.uid}) : super(key: key);

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  PageController? _pageController;

  int currentIndex = 0;

  List<Widget>? get pages => [
        AllUserPage(uid: widget.uid),
        GroupPage(
          uid: widget.uid,
        ),
      ];
  @override
  void initState() {
    _pageController = PageController(initialPage: currentIndex, keepPage: true);
    log("calling main...");

    BlocProvider.of<UserBloc>(context).add(GetUserEvent());

    BlocProvider.of<GroupBloc>(context).add(GetGroupEvent());

    super.initState();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(builder: (context, userState) {
      return BlocBuilder<UserBloc, UserState>(builder: (context, userState) {
        if (userState is UserLoaded) {
          return Scaffold(
              floatingActionButton: currentIndex == 0
                  ? FloatingActionButton(
                      backgroundColor: AppConstant.PRIMARY_COLOR,
                      mini: true,
                      onPressed: () {
                        Navigator.pushNamed(context, CreateGroupPage.routeName,
                            arguments: widget.uid);
                      },
                      child: const Center(
                        child: Icon(Icons.add_outlined),
                      ))
                  : Container(),
              body: PageView.builder(
                  physics: const BouncingScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: (val) {
                    setState(() {
                      currentIndex = val;
                    });
                  },
                  itemCount: pages!.length,
                  itemBuilder: (context, index) {
                    return pages![index];
                  }),
              bottomNavigationBar: BottomNavigationBar(
                  fixedColor: AppConstant.PRIMARY_COLOR,
                  selectedLabelStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppConstant.PRIMARY_COLOR),
                  elevation: 5,
                  onTap: (index) {
                    setState(() {
                      currentIndex = index;
                      _pageController?.animateToPage(index,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeIn);
                    });
                  },
                  currentIndex: currentIndex,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.group_outlined,
                        color: AppConstant.PRIMARY_COLOR,
                      ),
                      label: "Groups",
                      activeIcon: Icon(
                        Icons.person,
                        color: AppConstant.PRIMARY_COLOR,
                      ),
                    ),
                    BottomNavigationBarItem(
                      label: "Users",
                      icon: Icon(
                        Icons.person_outline,
                        color: AppConstant.PRIMARY_COLOR,
                      ),
                      activeIcon: Icon(
                        Icons.person,
                        color: AppConstant.PRIMARY_COLOR,
                      ),
                    ),
                  ]),
              appBar: CustomAppBar(
                actionWidgets: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: GestureDetector(
                      onTap: () {
                        logOutTheUser(context);
                      },
                      child: const Icon(Icons.logout_outlined),
                    ),
                  )
                ],
                title: "Chat Page",
                leading: SizedBox(
                  child: GestureDetector(
                    child: Hero(
                      tag: "h1",
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, ProfilePage.routeName,
                              arguments: userState.users.firstWhere(
                                  (element) => element.userId == widget.uid));
                        },
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(userState.users
                                  .where(
                                      (element) => element.userId == widget.uid)
                                  .first
                                  .profileUrl ??
                              AppConstant.defaulutUrl),
                        ),
                      ),
                    ),
                  ),
                ),
              ));
        } else {
          return Container(
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(
                backgroundColor: AppConstant.PRIMARY_COLOR,
              ),
            ),
          );
        }
      });
    });
  }

  void logOutTheUser(context) {
    BlocProvider.of<AuthBloc>(context).add(SignedOutEvent());
    Navigator.pushNamedAndRemoveUntil(
        context, SignInPage.routeName, (route) => false);
  }
}
