part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AppStartedEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}

class LoggedInEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}

class UpdateChattingWithEvent extends AuthEvent {
  String uid;
  List<String> users;

  UpdateChattingWithEvent({required this.uid, required this.users});
  List<Object> get props => [uid, users];
}

class SignedOutEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}
