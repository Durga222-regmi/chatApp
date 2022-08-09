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
