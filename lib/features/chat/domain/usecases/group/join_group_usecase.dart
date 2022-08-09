import 'package:group_chat_fb/core/type_def/type_def_constant.dart';
import 'package:group_chat_fb/core/use_case/usecase.dart';
import 'package:group_chat_fb/features/chat/domain/entity/group_entity.dart';
import 'package:group_chat_fb/features/chat/domain/repository/chat_repository.dart';

class JoinGroupUsecase extends UseCase<FutureVoid, JoinGroupUsecasePrams> {
  final ChatRepository repository;
  JoinGroupUsecase({required this.repository});

  @override
  FutureVoid call(JoinGroupUsecasePrams params) async {
    await repository.joinGroup(params.groupEntity);
  }
}

class JoinGroupUsecasePrams {
  GroupEntity groupEntity;
  JoinGroupUsecasePrams({required this.groupEntity});
}
