part of 'credential_bloc.dart';

abstract class CredentialState extends Equatable {
  const CredentialState();

  @override
  List<Object> get props => [];
}

class CredentialInitial extends CredentialState {
  @override
  List<Object> get props => [];
}

class CredentialLoading extends CredentialState {
  @override
  List<Object> get props => [];
}

class CredentialSuccess extends CredentialState {
  @override
  List<Object> get props => [];
}

class CredentialFailure extends CredentialState {
  @override
  List<Object> get props => [];
}

class ForgotPasswordEmailSending extends CredentialState {}

class ForgotPasswordEmailSent extends CredentialState {}

class ForgotPasswordEmailSendingFailure extends CredentialState {}
