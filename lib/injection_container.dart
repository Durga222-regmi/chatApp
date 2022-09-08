import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:group_chat_fb/features/authentication/data/datasource/remote/auth_remote_data_source.dart';
import 'package:group_chat_fb/features/authentication/data/datasource/remote/auth_remote_data_source_impl.dart';
import 'package:group_chat_fb/features/authentication/data/repository/auth_repository_imp.dart';
import 'package:group_chat_fb/features/authentication/domain/repository/auth_repository.dart';
import 'package:group_chat_fb/features/authentication/domain/usecases/forgot_password_usecase.dart';
import 'package:group_chat_fb/features/authentication/domain/usecases/get_all_user_usecase.dart';
import 'package:group_chat_fb/features/authentication/domain/usecases/get_current_create_user_usecase.dart';
import 'package:group_chat_fb/features/authentication/domain/usecases/get_current_user_id_usecase.dart';
import 'package:group_chat_fb/features/authentication/domain/usecases/get_update_user_usecase.dart';
import 'package:group_chat_fb/features/authentication/domain/usecases/google_auth_usecase.dart';
import 'package:group_chat_fb/features/authentication/domain/usecases/is_signed_in_usecase.dart';
import 'package:group_chat_fb/features/authentication/domain/usecases/sign_in_usecase.dart';
import 'package:group_chat_fb/features/authentication/domain/usecases/sign_out_usecase.dart';
import 'package:group_chat_fb/features/authentication/domain/usecases/sign_up_use_case.dart';
import 'package:group_chat_fb/features/authentication/domain/usecases/update_chatting_with_usecase.dart';
import 'package:group_chat_fb/features/authentication/presentation/bloc/auth/bloc/auth_bloc.dart';
import 'package:group_chat_fb/features/authentication/presentation/bloc/credential/bloc/credential_bloc.dart';
import 'package:group_chat_fb/features/authentication/presentation/bloc/user/bloc/user_bloc.dart';
import 'package:group_chat_fb/features/chat/data/datasources/remote_data_source/chat_remote_data_source.dart';
import 'package:group_chat_fb/features/chat/data/datasources/remote_data_source/chat_remote_data_source_impl.dart';
import 'package:group_chat_fb/features/chat/data/repository/chat_repository_impl.dart';
import 'package:group_chat_fb/features/chat/domain/repository/chat_repository.dart';
import 'package:group_chat_fb/features/chat/domain/usecases/chat/add_to_my_chat_usecase.dart';
import 'package:group_chat_fb/features/chat/domain/usecases/chat/create_one_to_one_channel_usecase.dart';
import 'package:group_chat_fb/features/chat/domain/usecases/chat/get_channel_id_usecase.dart';
import 'package:group_chat_fb/features/chat/domain/usecases/chat/get_my_chat_usecase.dart';
import 'package:group_chat_fb/features/chat/domain/usecases/chat/get_text_messages_usecase.dart';
import 'package:group_chat_fb/features/chat/domain/usecases/chat/send_text_message_usecase.dart';
import 'package:group_chat_fb/features/chat/domain/usecases/group/create_new_group_usecase.dart';
import 'package:group_chat_fb/features/chat/domain/usecases/group/get_create_group_usecase.dart';
import 'package:group_chat_fb/features/chat/domain/usecases/group/get_group_usecase.dart';
import 'package:group_chat_fb/features/chat/domain/usecases/group/get_single_group_usecase.dart';
import 'package:group_chat_fb/features/chat/domain/usecases/group/join_group_usecase.dart';
import 'package:group_chat_fb/features/chat/domain/usecases/group/update_group_usecase.dart';
import 'package:group_chat_fb/features/chat/presentation/bloc/chat/chat_bloc.dart';
import 'package:group_chat_fb/features/chat/presentation/bloc/group/group_bloc.dart';
import 'package:group_chat_fb/features/chat/presentation/bloc/myChatBloc/my_chat_bloc_bloc.dart';

GetIt sl = GetIt.instance;

Future<void> init() async {
  // Bloc

  sl.registerFactory<AuthBloc>(() => AuthBloc(
      getCurrentUserIdUsecase: sl.call(),
      isSignedInUsecase: sl.call(),
      signOutUseCase: sl.call()));
  sl.registerFactory<CredentialBloc>(() => CredentialBloc(
      forgotPasswordUsecase: sl.call(),
      getCurrentCreateUserUsecase: sl.call(),
      googleAuthUsecase: sl.call(),
      signInUsecase: sl.call(),
      signUpUsecase: sl.call()));
  sl.registerFactory<UserBloc>(() => UserBloc(
      getAllUserUsecase: sl.call(),
      getUpdateUserUsecase: sl.call(),
      updateChattingWithUsecase: sl.call()));
  sl.registerFactory<ChatBloc>(
    () => ChatBloc(
      createOneToOneChannelUsecase: sl.call(),
      getTextMessageUseCase: sl.call(),
      sendTextMessageUseCase: sl.call(),
    ),
  );
  sl.registerFactory<MyChatBloc>(
    () => MyChatBloc(
      addToMyChatUseCase: sl.call(),
      getMyChatUsecase: sl.call(),
    ),
  );
  sl.registerFactory<GroupBloc>(() => GroupBloc(
      getCreateGroupUsecase: sl.call(),
      getGroupUsecase: sl.call(),
      joinGroupUsecase: sl.call(),
      updateGroupUsecase: sl.call(),
      getSingleGroupUsecase: sl.call()));

// Usecases

  sl.registerLazySingleton<GetCreateGroupUsecase>(
      () => GetCreateGroupUsecase(repository: sl.call()));
  sl.registerLazySingleton<GetSingleGroupUsecase>(
      () => GetSingleGroupUsecase(repository: sl.call()));
  sl.registerLazySingleton<AddToMyChatUseCase>(
      () => AddToMyChatUseCase(repository: sl.call()));
  sl.registerLazySingleton<CreateOneToOneChannelUsecase>(
      () => CreateOneToOneChannelUsecase(repository: sl.call()));
  sl.registerLazySingleton<GetChannelIdUsecase>(
      () => GetChannelIdUsecase(repository: sl.call()));
  sl.registerLazySingleton<GetMyChatUsecase>(
      () => GetMyChatUsecase(repository: sl.call()));
  sl.registerLazySingleton<GetTextMessageUsecase>(
      () => GetTextMessageUsecase(repository: sl.call()));
  sl.registerLazySingleton<SendTextMessageUsecase>(
      () => SendTextMessageUsecase(repository: sl.call()));
  sl.registerLazySingleton<CreateNewGroupUsecase>(
      () => CreateNewGroupUsecase(repository: sl.call()));
  sl.registerLazySingleton<UpdateChattingWithUsecase>(
      () => UpdateChattingWithUsecase(repository: sl.call()));

  sl.registerLazySingleton<GetGroupUsecase>(
      () => GetGroupUsecase(repository: sl.call()));
  sl.registerLazySingleton<JoinGroupUsecase>(
      () => JoinGroupUsecase(repository: sl.call()));
  sl.registerLazySingleton<UpdateGroupUsecase>(
      () => UpdateGroupUsecase(repository: sl.call()));

  sl.registerLazySingleton<SignInUsecase>(
      () => SignInUsecase(repository: sl.call()));
  sl.registerLazySingleton<SignOutUseCase>(
      () => SignOutUseCase(repository: sl.call()));
  sl.registerLazySingleton<ForgotPasswordUsecase>(
      () => ForgotPasswordUsecase(repository: sl.call()));
  sl.registerLazySingleton<GetAllUserUsecase>(
      () => GetAllUserUsecase(repository: sl.call()));
  sl.registerLazySingleton<GetCurrentUserIdUsecase>(
      () => GetCurrentUserIdUsecase(repository: sl.call()));
  sl.registerLazySingleton<GetCurrentCreateUserUsecase>(
      () => GetCurrentCreateUserUsecase(repository: sl.call()));
  sl.registerLazySingleton<GetUpdateUserUsecase>(
      () => GetUpdateUserUsecase(repository: sl.call()));
  sl.registerLazySingleton<GoogleAuthUsecase>(
      () => GoogleAuthUsecase(repository: sl.call()));
  sl.registerLazySingleton<IsSignedInUsecase>(
      () => IsSignedInUsecase(repository: sl.call()));
  sl.registerLazySingleton<SignUpUsecase>(
      () => SignUpUsecase(repository: sl.call()));

// Repository

  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: sl.call()));
  sl.registerLazySingleton<ChatRepository>(
      () => ChatRepositoryImpl(chatRemoteDataSource: sl.call()));

// RemoteDataSource

  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(
      firebaseAuth: sl.call(),
      firebaseFirestore: sl.call(),
      gSignIn: sl.call()));
  sl.registerLazySingleton<ChatRemoteDataSource>(() => ChatRemoteDataSourceImpl(
        firebaseAuth: sl.call(),
        firebaseFirestore: sl.call(),
      ));

  // External

  final auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  sl.registerLazySingleton(() => auth);
  sl.registerLazySingleton(() => fireStore);
  sl.registerLazySingleton(() => googleSignIn);
}
