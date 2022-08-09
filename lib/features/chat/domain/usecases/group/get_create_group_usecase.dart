import 'package:dartz/dartz.dart';
import 'package:group_chat_fb/core/error/failure.dart';
import 'package:group_chat_fb/core/use_case/usecase.dart';
import 'package:group_chat_fb/features/chat/domain/entity/group_entity.dart';
import 'package:group_chat_fb/features/chat/domain/repository/chat_repository.dart';

class GetCreateGroupUsecase extends UseCase<void, GetCreateGroupUsecasePrams> {
  final ChatRepository repository;
  GetCreateGroupUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(GetCreateGroupUsecasePrams params) async {
    return await repository.getCreateGroup(params.groupEntity);
  }
}

class GetCreateGroupUsecasePrams {
  GroupEntity groupEntity;
  GetCreateGroupUsecasePrams({required this.groupEntity});
}
