part of 'my_chat_bloc_bloc.dart';

abstract class MyChatBlocEvent extends Equatable {
  const MyChatBlocEvent();

  @override
  List<Object> get props => [];
}

class AddToMyChatEvent extends MyChatBlocEvent {
  MyChatEntity myChatEntity;
  AddToMyChatEvent({
    required this.myChatEntity,
  });

  @override
  List<Object> get props => [myChatEntity];
}

class GetMyChatEvent extends MyChatBlocEvent {
  String uid;
  GetMyChatEvent({
    required this.uid,
  });

  @override
  List<Object> get props => [uid];
}
