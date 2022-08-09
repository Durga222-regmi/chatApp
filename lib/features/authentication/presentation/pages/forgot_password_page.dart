import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_chat_fb/app_constant.dart';
import 'package:group_chat_fb/core/dynamic_widgets/custom_app_bar.dart';
import 'package:group_chat_fb/features/authentication/presentation/bloc/credential/bloc/credential_bloc.dart';
import 'package:group_chat_fb/features/authentication/presentation/widgets/forgot_password/forgot_password_body.dart';

class ForgotPasswordPage extends StatelessWidget {
  static const routeName = "/forgot_password_page";
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CredentialBloc, CredentialState>(
      builder: (context, credentialState) {
        return Scaffold(
          appBar: CustomAppBar(title: "Forgot Password"),
          body: credentialState is ForgotPasswordEmailSending
              ? const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: AppConstant.PRIMARY_COLOR,
                  ),
                )
              : _buildBody(),
        );
      },
      listener: (context, authState) {
        if (authState is ForgotPasswordEmailSent) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Link sent successfully")));
        } else if (authState is ForgotPasswordEmailSendingFailure) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Something went wrong! please try again")));
        }
      },
    );
  }

  _buildBody() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: ForgotPasswordBody(),
    );
  }
}
