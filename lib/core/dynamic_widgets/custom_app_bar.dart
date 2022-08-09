import 'package:flutter/material.dart';
import 'package:group_chat_fb/app_constant.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  List<Widget>? actionWidgets;
  Widget? leading;
  CustomAppBar({Key? key, this.title, this.actionWidgets, this.leading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        leadingWidth: 60,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: leading ?? Container(),
        ),
        elevation: 0,
        actions: actionWidgets ?? [Container()],
        centerTitle: true,
        backgroundColor: AppConstant.PRIMARY_COLOR,
        title: Text(
          title ?? "",
        ));
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(75);
}
