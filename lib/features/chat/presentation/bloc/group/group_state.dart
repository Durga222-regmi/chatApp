part of 'group_bloc.dart';

abstract class GroupState extends Equatable {
  const GroupState();

  @override
  List<Object> get props => [];
}

class GroupInitial extends GroupState {}

class GroupLoading extends GroupState {}

class GroupJoining extends GroupState {}

class GroupJoined extends GroupState {}

class GroupJoinFailure extends GroupState {
  final String joinFailureMsg;
  const GroupJoinFailure({required this.joinFailureMsg});
}

class GroupLoaded extends GroupState {
  final List<GroupEntity> groupEntities;
  const GroupLoaded({required this.groupEntities});
  @override
  List<Object> get props => [groupEntities];
}

class GroupFailure extends GroupState {
  final String failureMessage;
  const GroupFailure({required this.failureMessage});
  @override
  List<Object> get props => [failureMessage];
}

class GroupCreated extends GroupState {
  final String successMessage;
  const GroupCreated({required this.successMessage});
}
