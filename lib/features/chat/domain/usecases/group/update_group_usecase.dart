import 'package:group_chat_fb/core/type_def/type_def_constant.dart';
import 'package:group_chat_fb/core/use_case/usecase.dart';
import 'package:group_chat_fb/features/chat/domain/entity/group_entity.dart';
import 'package:group_chat_fb/features/chat/domain/repository/chat_repository.dart';

class UpdateGroupUsecase extends UseCase<FutureVoid, UpdateGroupUsecasePrams> {
  final ChatRepository repository;
  UpdateGroupUsecase({required this.repository});

  @override
  FutureVoid call(UpdateGroupUsecasePrams params) async {
    await repository.updateGroup(params.groupEntity);
  }
}

class UpdateGroupUsecasePrams {
  GroupEntity groupEntity;
  UpdateGroupUsecasePrams({required this.groupEntity});
}
