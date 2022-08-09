import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_chat_fb/app_constant.dart';
import 'package:group_chat_fb/features/authentication/domain/enitity/user_entity.dart';
import 'package:group_chat_fb/features/authentication/presentation/bloc/credential/bloc/credential_bloc.dart';
import 'package:group_chat_fb/features/authentication/presentation/pages/sing_in_page.dart';

class SignUpBody extends StatefulWidget {
  const SignUpBody({Key? key}) : super(key: key);

  @override
  State<SignUpBody> createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _usernameController,
                  cursorColor: AppConstant.PRIMARY_COLOR,
                  cursorHeight: 20,
                  cursorWidth: 2,
                  decoration: const InputDecoration(hintText: "Enter name"),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _emailController,
                  cursorColor: AppConstant.PRIMARY_COLOR,
                  cursorHeight: 20,
                  cursorWidth: 2,
                  decoration: const InputDecoration(hintText: "Enter email"),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _passwordController,
                  cursorColor: AppConstant.PRIMARY_COLOR,
                  cursorHeight: 20,
                  cursorWidth: 2,
                  decoration: const InputDecoration(hintText: "Enter password"),
                ),
                const SizedBox(
                  height: 10,
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
                submitSignUp();
              },
              child: const Text(
                "Create Account",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            child: TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, SignInPage.routeName, (route) => false);
                },
                child: const Text(
                  "Login",
                  style: TextStyle(
                      color: AppConstant.PRIMARY_COLOR,
                      fontWeight: FontWeight.w600),
                )),
          )
        ],
      ),
    );
  }

  void submitSignUp() {
    if (_emailController.text.isNotEmpty &&
        _usernameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      final email = _emailController.text;
      final password = _passwordController.text;
      final userName = _usernameController.text;
      BlocProvider.of<CredentialBloc>(context).add(SignUpEvent(
          userEntity:
              UserEntity(email: email, password: password, name: userName)));
    }
  }
}
