import 'package:flutter/material.dart';
import 'package:group_chat_fb/app_constant.dart';

class CustomLoaderWidget extends StatelessWidget {
  String? message;
  CustomLoaderWidget({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            backgroundColor: AppConstant.PRIMARY_COLOR,
          ),
          const SizedBox(
            height: 5,
          ),
          if (message != null) ...{Text(message!)}
        ],
      ),
    );
  }
}
