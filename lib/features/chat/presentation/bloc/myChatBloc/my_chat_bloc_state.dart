part of 'my_chat_bloc_bloc.dart';

abstract class MyChatBlocState extends Equatable {
  const MyChatBlocState();

  @override
  List<Object> get props => [];
}

class MyChatBlocInitial extends MyChatBlocState {}

class MyChatLoading extends MyChatBlocState {}

class MyChatLoaded extends MyChatBlocState {
  List<MyChatEntity> myChatEntities;
  MyChatLoaded({required this.myChatEntities});
}

class MyChatLoadFailure extends MyChatBlocState {
  String failureMessage;
  MyChatLoadFailure({required this.failureMessage});
}
