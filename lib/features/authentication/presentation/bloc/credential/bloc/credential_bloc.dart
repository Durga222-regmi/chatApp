import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:group_chat_fb/core/use_case/usecase.dart';
import 'package:group_chat_fb/features/authentication/domain/enitity/user_entity.dart';
import 'package:group_chat_fb/features/authentication/domain/usecases/forgot_password_usecase.dart';
import 'package:group_chat_fb/features/authentication/domain/usecases/get_current_create_user_usecase.dart';
import 'package:group_chat_fb/features/authentication/domain/usecases/google_auth_usecase.dart';
import 'package:group_chat_fb/features/authentication/domain/usecases/sign_in_usecase.dart';
import 'package:group_chat_fb/features/authentication/domain/usecases/sign_up_use_case.dart';

part 'credential_event.dart';
part 'credential_state.dart';

class CredentialBloc extends Bloc<CredentialEvent, CredentialState> {
  final SignInUsecase signInUsecase;
  final SignUpUsecase signUpUsecase;
  final ForgotPasswordUsecase forgotPasswordUsecase;
  final GoogleAuthUsecase googleAuthUsecase;
  final GetCurrentCreateUserUsecase getCurrentCreateUserUsecase;

  CredentialBloc(
      {required this.forgotPasswordUsecase,
      required this.googleAuthUsecase,
      required this.signInUsecase,
      required this.signUpUsecase,
      required this.getCurrentCreateUserUsecase})
      : super(CredentialInitial()) {
    on<SignInEvent>((event, emit) async {
      emit(CredentialLoading());
      try {
        await signInUsecase(SignInUsecasePrams(
            entity: UserEntity(email: event.email, password: event.passWord)));

        emit(CredentialSuccess());
      } catch (e) {
        emit(CredentialFailure());
      }
    });

    on<GoogleAuthenticationEvent>((event, emit) async {
      emit(CredentialLoading());
      try {
        await googleAuthUsecase(NoParams());
        emit(CredentialSuccess());
      } catch (e) {
        log(e.toString());
        emit(CredentialFailure());
      }
    });
    on<SignUpEvent>((event, emit) async {
      emit(CredentialLoading());
      try {
        await signUpUsecase(SignUpUsecasePrams(
            entity: UserEntity(
                email: event.userEntity.email,
                password: event.userEntity.password)));
        await getCurrentCreateUserUsecase(
            GetCurrentCreateUserUsecaseParams(user: event.userEntity));

        emit(CredentialSuccess());
      } catch (e) {
        log(e.toString());
        emit(CredentialFailure());
      }
    });
    on<ForgotPasswordEvent>((event, emit) async {
      emit(ForgotPasswordEmailSending());
      try {
        await forgotPasswordUsecase(ForgotPasswordParams(email: event.email));
        emit(ForgotPasswordEmailSent());
      } catch (e) {
        log(e.toString());
        emit(ForgotPasswordEmailSendingFailure());
      }
    });
  }
}
