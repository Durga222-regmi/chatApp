import 'package:dartz/dartz.dart';
import 'package:group_chat_fb/core/enum/enums.dart';
import 'package:group_chat_fb/core/error/failure.dart';
import 'package:group_chat_fb/core/use_case/usecase.dart';
import 'package:group_chat_fb/features/chat/domain/repository/chat_repository.dart';

class UpdateMessageStatusUsecase
    extends UseCase<void, UpdateMessageStatusUsecaseParams> {
  ChatRepository chatRepository;
  UpdateMessageStatusUsecase({required this.chatRepository});
  @override
  Future<Either<Failure, void>> call(
      UpdateMessageStatusUsecaseParams params) async {
    return await chatRepository.updateMessageStatus(
        params.messageId, params.status, params.messageType, params.channelId);
  }
}

class UpdateMessageStatusUsecaseParams {
  String messageId;
  String status;
  MessageType messageType;
  String channelId;
  UpdateMessageStatusUsecaseParams(
      {required this.messageId,
      required this.status,
      required this.messageType,
      required this.channelId});
}
