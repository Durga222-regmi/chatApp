import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_chat_fb/features/authentication/presentation/pages/sign_up_page.dart';
import 'package:group_chat_fb/page_constant.dart';

import '../../../../../app_constant.dart';
import '../../bloc/credential/bloc/credential_bloc.dart';

class SignInBody extends StatefulWidget {
  const SignInBody({Key? key}) : super(key: key);

  @override
  State<SignInBody> createState() => _SignInBodyState();
}

class _SignInBodyState extends State<SignInBody> {
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
                  decoration: const InputDecoration(
                    hintText: "Enter password",
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                            context, PageConstant.forgotPasswordPage);
                      },
                      child: const SizedBox(
                          height: 20,
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ))),
                )
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
                submitSignIn();
              },
              child: const Text(
                "Login",
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
            child: OutlinedButton(
              onPressed: () {
                submitGoogleSignIn();
              },
              child: const Text(
                "Sign in with Google",
                style: TextStyle(
                    color: AppConstant.PRIMARY_COLOR,
                    fontWeight: FontWeight.w600),
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
                      context, SignUpPage.routeName, (route) => false);
                },
                child: const Text(
                  "Create Account",
                  style: TextStyle(
                      color: AppConstant.PRIMARY_COLOR,
                      fontWeight: FontWeight.w600),
                )),
          )
        ],
      ),
    );
  }

  void submitSignIn() {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      final email = _emailController.text;
      final password = _passwordController.text;

      BlocProvider.of<CredentialBloc>(context)
          .add(SignInEvent(email: email, passWord: password));
    }
  }

  void submitGoogleSignIn() {
    BlocProvider.of<CredentialBloc>(context).add(GoogleAuthenticationEvent());
  }
}
