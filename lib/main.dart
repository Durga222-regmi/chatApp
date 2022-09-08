import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_chat_fb/core/services/firebase_messaging_service.dart';
import 'package:group_chat_fb/features/chat/presentation/bloc/myChatBloc/my_chat_bloc_bloc.dart';
import 'package:group_chat_fb/firebase_options.dart';

import 'features/authentication/presentation/bloc/auth/bloc/auth_bloc.dart';
import 'features/authentication/presentation/bloc/credential/bloc/credential_bloc.dart';
import 'features/authentication/presentation/bloc/user/bloc/user_bloc.dart';
import 'features/authentication/presentation/pages/sing_in_page.dart';
import 'features/chat/presentation/bloc/chat/chat_bloc.dart';
import 'features/chat/presentation/bloc/group/group_bloc.dart';
import 'features/chat/presentation/pages/chat_home_page.dart';
import 'injection_container.dart' as di;
import 'on_generate_route_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await di.init();
  FirebaseMessagingService.configLocalNotification();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
              create: (context) => di.sl<AuthBloc>()..add(AppStartedEvent())),
          BlocProvider<UserBloc>(
            create: (context) => di.sl<UserBloc>()..add(GetUserEvent()),
          ),
          BlocProvider<CredentialBloc>(
              create: (context) => di.sl<CredentialBloc>()),
          BlocProvider<ChatBloc>(create: (context) => di.sl<ChatBloc>()),
          BlocProvider<GroupBloc>(create: (context) => di.sl<GroupBloc>()),
          BlocProvider<MyChatBloc>(create: (context) => di.sl<MyChatBloc>())
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: "/",
          onGenerateRoute: OnGenerateRoute.route,
          routes: {
            "/": (context) {
              return BlocBuilder<AuthBloc, AuthState>(builder: (_, authState) {
                if (authState is Authenticated) {
                  return ChatHomePage(
                    uid: authState.uid,
                  );
                } else {
                  return const SignInPage();
                }
              });
            }
          },
        ));
  }
}
