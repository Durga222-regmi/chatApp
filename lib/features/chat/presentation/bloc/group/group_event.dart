part of 'group_bloc.dart';

abstract class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object> get props => [];
}

class GetCreateGroupEvent extends GroupEvent {
  File file;
  GroupEntity groupEntity;
  GetCreateGroupEvent({required this.groupEntity, required this.file});
}

class GetGroupEvent extends GroupEvent {}

class JoinGroupEvent extends GroupEvent {
  GroupEntity groupEntity;
  JoinGroupEvent({required this.groupEntity});
}

class UpdateGroupEvent extends GroupEvent {
  GroupEntity groupEntity;
  UpdateGroupEvent({required this.groupEntity});
}
