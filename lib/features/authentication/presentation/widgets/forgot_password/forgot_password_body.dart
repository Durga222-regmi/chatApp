import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_chat_fb/features/authentication/presentation/bloc/credential/bloc/credential_bloc.dart';

import '../../../../../app_constant.dart';

class ForgotPasswordBody extends StatefulWidget {
  const ForgotPasswordBody({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordBody> createState() => _ForgotPasswordBodyState();
}

class _ForgotPasswordBodyState extends State<ForgotPasswordBody> {
  final TextEditingController _forgotPassworController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                  "We will send you a link for reset the password in your email"),
              Center(
                child: TextFormField(
                  controller: _forgotPassworController,
                  cursorColor: AppConstant.PRIMARY_COLOR,
                  cursorHeight: 20,
                  cursorWidth: 2,
                  decoration: const InputDecoration(
                    hintText: "Enter email",
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ButtonStyle(
                elevation: MaterialStateProperty.all(10),
                backgroundColor:
                    MaterialStateProperty.all(AppConstant.PRIMARY_COLOR)),
            onPressed: () {
              subMitForgotPassword();
            },
            child: const Text(
              "Send link ",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  void subMitForgotPassword() {
    log(_forgotPassworController.text);
    BlocProvider.of<CredentialBloc>(context)
        .add(ForgotPasswordEvent(email: _forgotPassworController.text));
  }
}
