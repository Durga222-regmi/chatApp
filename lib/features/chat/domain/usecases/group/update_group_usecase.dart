import 'package:dartz/dartz.dart';
import 'package:group_chat_fb/core/error/failure.dart';
import 'package:group_chat_fb/core/use_case/usecase.dart';
import 'package:group_chat_fb/features/chat/domain/entity/group_entity.dart';
import 'package:group_chat_fb/features/chat/domain/repository/chat_repository.dart';

class UpdateGroupUsecase extends UseCase<void, UpdateGroupUsecasePrams> {
  final ChatRepository repository;
  UpdateGroupUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(UpdateGroupUsecasePrams params) async {
    return await repository.updateGroup(params.groupEntity);
  }
}

class UpdateGroupUsecasePrams {
  GroupEntity groupEntity;
  UpdateGroupUsecasePrams({required this.groupEntity});
}
