part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  List<TextMessageEntity> textMessages;
  ChatLoaded({required this.textMessages});
  @override
  List<Object> get props => [textMessages];
}

class ChatFailure extends ChatState {
  String failureMessage;
  ChatFailure({required this.failureMessage});
  @override
  List<Object> get props => [failureMessage];
}
