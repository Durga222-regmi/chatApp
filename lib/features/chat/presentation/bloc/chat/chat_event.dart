part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class GetTextMessageEvent extends ChatEvent {
  MessageType messageType;
  String channelId;
  GetTextMessageEvent({required this.channelId, required this.messageType});
  @override
  List<Object> get props => [channelId];
}

class SendTextMessageEvent extends ChatEvent {
  TextMessageEntity textMessageEntity;
  String channelId;
  MessageType messageType;

  SendTextMessageEvent(
      {required this.channelId,
      required this.textMessageEntity,
      required this.messageType});
  @override
  List<Object> get props => [textMessageEntity, channelId];
}

class CreateOneToOneChannelEvent extends ChatEvent {
  EngageUserEntity engageUserEntity;
  CreateOneToOneChannelEvent({required this.engageUserEntity});
  @override
  List<Object> get props => [engageUserEntity];
}

class GetChannelIdEvent extends ChatEvent {
  EngageUserEntity engageUserEntity;
  GetChannelIdEvent({required this.engageUserEntity});
  @override
  List<Object> get props => [engageUserEntity];
}
