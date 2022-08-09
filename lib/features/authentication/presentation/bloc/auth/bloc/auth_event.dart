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

class SignedOutEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}
