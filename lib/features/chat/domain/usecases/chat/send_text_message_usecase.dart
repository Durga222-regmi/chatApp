import 'package:dartz/dartz.dart';
import 'package:group_chat_fb/core/enum/enums.dart';
import 'package:group_chat_fb/core/error/failure.dart';
import 'package:group_chat_fb/core/use_case/usecase.dart';
import 'package:group_chat_fb/features/chat/domain/entity/text_message_entity.dart';
import 'package:group_chat_fb/features/chat/domain/repository/chat_repository.dart';

class SendTextMessageUsecase
    extends UseCase<void, SendTextMessageUsecasePrams> {
  final ChatRepository repository;
  SendTextMessageUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(SendTextMessageUsecasePrams params) async {
    return await repository.getTextMessages(
      params.messageType,
      params.channelId,
    );
  }
}

class SendTextMessageUsecasePrams {
  TextMessageEntity textMessageEntity;
  String channelId;
  MessageType messageType;
  SendTextMessageUsecasePrams(
      {required this.channelId,
      required this.textMessageEntity,
      required this.messageType});
}
