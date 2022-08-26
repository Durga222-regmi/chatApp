import 'package:flutter/material.dart';
import 'package:group_chat_fb/app_constant.dart';
import 'package:group_chat_fb/features/authentication/domain/enitity/user_entity.dart';

class ProfilePage extends StatelessWidget {
  UserEntity userEntity;

  static const routeName = "/profile_page";
  ProfilePage({Key? key, required this.userEntity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xffe7ecef),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: AppConstant.BORDER_COLOR),
              borderRadius: BorderRadius.circular(5),
              color: const Color(0xffe7ecef),
              boxShadow: const []),
          height: height * 0.5,
          width: width * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              Hero(
                tag: "h1",
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      userEntity.profileUrl ?? AppConstant.defaultUrl),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                userEntity.email.toString(),
                style: TextStyle(
                  color: Colors.grey[400]!,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
