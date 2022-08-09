import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_chat_fb/app_constant.dart';
import 'package:group_chat_fb/features/authentication/presentation/widgets/sign_in/sign_in_body.dart';

import '../../../../core/dynamic_widgets/custom_app_bar.dart';
import '../../../chat/presentation/pages/chat_home_page.dart';
import '../bloc/auth/bloc/auth_bloc.dart';
import '../bloc/credential/bloc/credential_bloc.dart';

class SignInPage extends StatelessWidget {
  static const routeName = "/sign_in_page";
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CredentialBloc, CredentialState>(
      builder: (context, credentialState) {
        if (credentialState is CredentialSuccess) {
          return BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              if (authState is Authenticated) {
                return ChatHomePage(
                  uid: authState.uid,
                );
              }
              return _bodyWidget();
            },
          );
        } else if (credentialState is CredentialLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppConstant.PRIMARY_COLOR,
            ),
          );
        } else {
          return _bodyWidget();
        }
      },
      listener: (context, credentialState) {
        if (credentialState is CredentialSuccess) {
          BlocProvider.of<AuthBloc>(context).add(LoggedInEvent());
        } else if (credentialState is CredentialFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Fill the credential correctly")));
        }
      },
    );
  }

  Widget _bodyWidget() {
    return Scaffold(
        appBar: CustomAppBar(
          title: "Sign In",
        ),
        body: const SignInBody());
  }
}
