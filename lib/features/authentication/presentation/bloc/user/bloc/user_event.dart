part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class GetUserEvent extends UserEvent {}

class GetUpdatedUser extends UserEvent {
  final UserEntity entity;
  const GetUpdatedUser({required this.entity});
}

class UpdateChattingWithEvent extends UserEvent {
  String uid;
  List<String> users;

  UpdateChattingWithEvent({required this.uid, required this.users});
  @override
  List<Object> get props => [uid, users];
}
