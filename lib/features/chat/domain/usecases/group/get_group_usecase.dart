import 'package:dartz/dartz.dart';
import 'package:group_chat_fb/core/error/failure.dart';
import 'package:group_chat_fb/core/type_def/type_def_constant.dart';
import 'package:group_chat_fb/core/use_case/usecase.dart';
import 'package:group_chat_fb/features/chat/domain/entity/group_entity.dart';
import 'package:group_chat_fb/features/chat/domain/repository/chat_repository.dart';

class GetGroupUsecase extends UseCase<StreamList<GroupEntity>, NoParams> {
  final ChatRepository repository;
  GetGroupUsecase({required this.repository});

  @override
  Future<Either<Failure, StreamList<GroupEntity>>> call(NoParams params) async {
    return await repository.getGroups();
  }
}
