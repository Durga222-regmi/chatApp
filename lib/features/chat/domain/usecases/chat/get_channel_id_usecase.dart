import 'package:dartz/dartz.dart';
import 'package:group_chat_fb/core/error/failure.dart';
import 'package:group_chat_fb/core/use_case/usecase.dart';
import 'package:group_chat_fb/features/chat/domain/entity/engage_user_entity.dart';
import 'package:group_chat_fb/features/chat/domain/repository/chat_repository.dart';

class GetChannelIdUsecase extends UseCase<void, GetChannelIdUsecasePrams> {
  final ChatRepository repository;
  GetChannelIdUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(GetChannelIdUsecasePrams params) async {
    return await repository.getChannelId(params.engageUserEntity);
  }
}

class GetChannelIdUsecasePrams {
  EngageUserEntity engageUserEntity;
  GetChannelIdUsecasePrams({required this.engageUserEntity});
}
