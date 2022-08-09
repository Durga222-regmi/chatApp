part of 'credential_bloc.dart';

abstract class CredentialEvent extends Equatable {
  const CredentialEvent();

  @override
  List<Object> get props => [];
}

class SignUpEvent extends CredentialEvent {
  final UserEntity userEntity;
  const SignUpEvent({required this.userEntity});

  @override
  List<Object> get props => [];
}

class SignInEvent extends CredentialEvent {
  final String email;
  final String passWord;

  const SignInEvent({required this.email, required this.passWord});
  @override
  List<Object> get props => [email, passWord];
}

class ForgotPasswordEvent extends CredentialEvent {
  final String email;
  const ForgotPasswordEvent({required this.email});

  @override
  List<Object> get props => [email];
}

class GoogleAuthenticationEvent extends CredentialEvent {
  @override
  List<Object> get props => [];
}
