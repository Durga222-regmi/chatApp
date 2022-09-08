import 'package:group_chat_fb/core/dynamic_widgets/video_calling_widget.dart';
import 'package:group_chat_fb/features/authentication/presentation/pages/forgot_password_page.dart';
import 'package:group_chat_fb/features/authentication/presentation/pages/sign_up_page.dart';
import 'package:group_chat_fb/features/authentication/presentation/pages/sing_in_page.dart';
import 'package:group_chat_fb/features/chat/presentation/pages/all_user_page.dart';
import 'package:group_chat_fb/features/chat/presentation/pages/chat_home_page.dart';
import 'package:group_chat_fb/features/chat/presentation/pages/create_group_page.dart';
import 'package:group_chat_fb/features/chat/presentation/pages/my_chat_page.dart';
import 'package:group_chat_fb/features/chat/presentation/pages/profile_page.dart';
import 'package:group_chat_fb/features/chat/presentation/pages/single_chat_page.dart';
import 'package:group_chat_fb/features/chat/presentation/pages/group_member_page.dart';

import 'features/chat/presentation/pages/group_page.dart';

class PageConstant {
  static const String signUpPage = SignUpPage.routeName;
  static const String signInPage = SignInPage.routeName;
  static const String forgotPasswordPage = ForgotPasswordPage.routeName;
  static const String chatHomePage = ChatHomePage.routeName;
  static const String allUserPage = AllUserPage.routeName;
  static const String groupPage = GroupPage.routeName;
  static const String profilePage = ProfilePage.routeName;
  static const String createGroup = CreateGroupPage.routeName;
  static const String singleChatPage = SingleChatPage.routeName;
  static const String myChatPage = MyChatPage.routeName;
  static const String groupMemberPage = GroupMemberPage.routeName;
  static const String videoCallingWidget = VideoCallingWidget.routeName;
}
