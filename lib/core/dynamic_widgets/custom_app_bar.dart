import 'package:flutter/material.dart';
import 'package:group_chat_fb/app_constant.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  List<Widget>? actionWidgets;
  Widget? leading;
  List<Text>? extraTitle;
  CustomAppBar(
      {Key? key, this.title, this.actionWidgets, this.leading, this.extraTitle})
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
        backgroundColor: AppConstant.PRIMARY_COLOR,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title ?? "",
            ),
            if (extraTitle != null) ...{
              const SizedBox(
                height: 4,
              ),
              for (var i in extraTitle!) i,
            }
          ],
        ));
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(75);
}
