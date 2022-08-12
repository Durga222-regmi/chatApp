import 'package:dartz/dartz.dart';
import 'package:group_chat_fb/core/error/failure.dart';
import 'package:group_chat_fb/core/use_case/usecase.dart';
import 'package:group_chat_fb/features/chat/domain/entity/group_entity.dart';
import 'package:group_chat_fb/features/chat/domain/repository/chat_repository.dart';

class JoinGroupUsecase extends UseCase<void, JoinGroupUsecasePrams> {
  final ChatRepository repository;
  JoinGroupUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(JoinGroupUsecasePrams params) async {
    return await repository.joinGroup(params.groupEntity);
  }
}

class JoinGroupUsecasePrams {
  GroupEntity groupEntity;
  JoinGroupUsecasePrams({required this.groupEntity});
}
