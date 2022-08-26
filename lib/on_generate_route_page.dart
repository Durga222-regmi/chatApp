import 'package:flutter/material.dart';
import 'package:group_chat_fb/features/authentication/domain/enitity/user_entity.dart';
import 'package:group_chat_fb/features/authentication/presentation/pages/forgot_password_page.dart';
import 'package:group_chat_fb/features/authentication/presentation/pages/sign_up_page.dart';
import 'package:group_chat_fb/features/authentication/presentation/pages/sing_in_page.dart';
import 'package:group_chat_fb/features/chat/presentation/pages/chat_home_page.dart';
import 'package:group_chat_fb/features/chat/presentation/pages/create_group_page.dart';
import 'package:group_chat_fb/features/chat/presentation/pages/my_chat_page.dart';
import 'package:group_chat_fb/features/chat/presentation/pages/profile_page.dart';
import 'package:group_chat_fb/features/chat/presentation/pages/single_chat_page.dart';
import 'package:group_chat_fb/features/chat/presentation/pages/group_member_page.dart';
import 'package:group_chat_fb/page_constant.dart';

class OnGenerateRoute {
  static Route<dynamic> route(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case PageConstant.signUpPage:
        {
          return materialBuilder(const SignUpPage());
        }
      case PageConstant.createGroup:
        {
          if (args is String) {
            return materialBuilder(CreateGroupPage(
              uid: args,
            ));
          } else {
            return materialBuilder(const ErrorPage());
          }
        }
      case PageConstant.singleChatPage:
        {
          if (args is List) {
            return materialBuilder(SingleChatPage(
              singleChatEntity: args[0],
              messageType: args[1],
              channelId: args.length > 2 ? args[2] ?? "" : "",
            ));
          } else {
            return materialBuilder(const ErrorPage());
          }
        }
      case PageConstant.signInPage:
        {
          return materialBuilder(const SignInPage());
        }
      case PageConstant.forgotPasswordPage:
        {
          return materialBuilder(const ForgotPasswordPage());
        }
      case PageConstant.chatHomePage:
        {
          if (args is String) {
            return materialBuilder(ChatHomePage(
              uid: args,
            ));
          } else {
            return materialBuilder(const ErrorPage());
          }
        }
      case PageConstant.profilePage:
        {
          if (args is UserEntity) {
            return materialBuilder(ProfilePage(
              userEntity: args,
            ));
          } else {
            return materialBuilder(const ErrorPage());
          }
        }
      case PageConstant.myChatPage:
        {
          if (args is String) {
            return materialBuilder(MyChatPage(
              uid: args,
            ));
          } else {
            return materialBuilder(const ErrorPage());
          }
        }
      case PageConstant.groupMemberPage:
        {
          if (args is String) {
            return materialBuilder(
              GroupMemberPage(
              groupId: args,
            ));
          } else {
            return materialBuilder(const ErrorPage());
          }
        }

      default:
        return materialBuilder(const ErrorPage());
    }
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

  static const ERROR_MESSAGE = "Error Page";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(ERROR_MESSAGE),
      ),
      body: const Center(
        child: Text(ERROR_MESSAGE),
      ),
    );
  }
}

MaterialPageRoute materialBuilder(Widget widget) {
  return MaterialPageRoute(builder: (_) {
    return widget;
  });
}
