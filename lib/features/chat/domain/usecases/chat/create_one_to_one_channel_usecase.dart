import 'package:dartz/dartz.dart';
import 'package:group_chat_fb/core/error/failure.dart';
import 'package:group_chat_fb/core/use_case/usecase.dart';
import 'package:group_chat_fb/features/chat/domain/entity/engage_user_entity.dart';
import 'package:group_chat_fb/features/chat/domain/repository/chat_repository.dart';

class CreateOneToOneChannelUsecase
    extends UseCase<void, CreateOneToOneChannelUsecasePrams> {
  final ChatRepository repository;
  CreateOneToOneChannelUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(
      CreateOneToOneChannelUsecasePrams params) async {
    return await repository.createOneToOneChannel(params.engageUserEntity);
  }
}

class CreateOneToOneChannelUsecasePrams {
  EngageUserEntity engageUserEntity;
  CreateOneToOneChannelUsecasePrams({required this.engageUserEntity});
}
