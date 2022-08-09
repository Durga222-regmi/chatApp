part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class Authenticated extends AuthState {
  String uid;
  Authenticated({required this.uid});

  @override
  List<Object> get props => [uid];
}

class UnAuthenticated extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthenticationFailure extends AuthState {
  final String message;
  const AuthenticationFailure({required this.message});
}
