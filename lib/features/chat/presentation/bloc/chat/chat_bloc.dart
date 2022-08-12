import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:group_chat_fb/core/enum/enums.dart';
import 'package:group_chat_fb/features/chat/domain/entity/engage_user_entity.dart';
import 'package:group_chat_fb/features/chat/domain/entity/text_message_entity.dart';
import 'package:group_chat_fb/features/chat/domain/usecases/chat/add_to_my_chat_usecase.dart';
import 'package:group_chat_fb/features/chat/domain/usecases/chat/create_one_to_one_channel_usecase.dart';
import 'package:group_chat_fb/features/chat/domain/usecases/chat/get_text_messages_usecase.dart';
import 'package:group_chat_fb/features/chat/domain/usecases/chat/send_text_message_usecase.dart';

import '../../../domain/entity/my_chat_entity.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  // AddToMyChatUseCase addToMyChatUseCase;
  GetTextMessageUsecase getTextMessageUseCase;
  SendTextMessageUsecase sendTextMessageUseCase;
  AddToMyChatUseCase addToMyChatUseCase;
  CreateOneToOneChannelUsecase createOneToOneChannelUsecase;

  ChatBloc(
      {
      // required this.addToMyChatUseCase,
      required this.getTextMessageUseCase,
      required this.sendTextMessageUseCase,
      required this.addToMyChatUseCase,
      required this.createOneToOneChannelUsecase})
      : super(ChatInitial()) {
    on<GetTextMessageEvent>((event, emit) async {
      emit(ChatLoading());

      final textMessagesOrFailure = await getTextMessageUseCase(
          GetTextMessageUsecaseParams(
              channelId: event.channelId, messageType: event.messageType));

      await textMessagesOrFailure.fold((failure) async {
        emit(ChatFailure(failureMessage: "Can not get messages"));
      }, (textMessages) async {
        await emit.forEach(textMessages,
            onData: (List<TextMessageEntity> textMessages) {
          log(textMessages.length.toString());
          return ChatLoaded(textMessages: textMessages);
        });
      });
    });

    on<SendTextMessageEvent>((event, emit) async {
      final resultOrFailure =
          await sendTextMessageUseCase(SendTextMessageUsecasePrams(
        channelId: event.channelId,
        textMessageEntity: event.textMessageEntity,
        messageType: event.messageType,
      ));

      await resultOrFailure.fold((failure) async {
        ChatFailure(failureMessage: "can not send message");
      }, (result) {
        log("message sent successfully");
      });
    });
    on<AddToMyChatEvent>((event, emit) async {
      final resultOrFailure = await addToMyChatUseCase(
          AddToMyChatUseCasePrams(myChatEntity: event.myChatEntity));

      resultOrFailure.fold((failure) async {
        ChatFailure(failureMessage: "can not send message");
      }, (result) async {
        log("message sent successfully");
      });
    });

    on<CreateOneToOneChannelEvent>((event, emit) async {
      final resultOrFailure = await createOneToOneChannelUsecase(
          CreateOneToOneChannelUsecasePrams(
              engageUserEntity: event.engageUserEntity));

      await resultOrFailure.fold((failure) async {
        ChatFailure(failureMessage: "can not send message");
      }, (result) async {
        log("result is $result");
        emit(ChatChannelCreated(channelID:  result));
      });
    });
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
