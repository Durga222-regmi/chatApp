import 'package:group_chat_fb/core/enum/enums.dart';
import 'package:group_chat_fb/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:group_chat_fb/core/type_def/type_def_constant.dart';
import 'package:group_chat_fb/core/use_case/usecase.dart';
import 'package:group_chat_fb/features/chat/domain/entity/text_message_entity.dart';
import 'package:group_chat_fb/features/chat/domain/repository/chat_repository.dart';

class GetTextMessageUsecase extends UseCase<StreamList<TextMessageEntity>,
    GetTextMessageUsecaseParams> {
  final ChatRepository repository;
  GetTextMessageUsecase({required this.repository});

  @override
  Future<Either<Failure, StreamList<TextMessageEntity>>> call(
      GetTextMessageUsecaseParams params) async {
    return await repository.getTextMessages(params.channelId,params.messageType);
  }
}

class GetTextMessageUsecaseParams {
  String channelId;
  MessageType messageType;
  GetTextMessageUsecaseParams({required this.channelId,required this.messageType);
}
