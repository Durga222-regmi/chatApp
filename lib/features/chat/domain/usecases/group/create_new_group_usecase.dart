import 'package:group_chat_fb/core/type_def/type_def_constant.dart';
import 'package:group_chat_fb/core/use_case/usecase.dart';
import 'package:group_chat_fb/features/chat/domain/entity/my_chat_entity.dart';
import 'package:group_chat_fb/features/chat/domain/repository/chat_repository.dart';

class CreateNewGroupUsecase
    extends UseCase<FutureVoid, CreateNewGroupUsecasePrams> {
  final ChatRepository repository;
  CreateNewGroupUsecase({required this.repository});

  @override
  FutureVoid call(CreateNewGroupUsecasePrams params) async {
    await repository.createNewGroup(
        params.myChatEntity, params.selectedUsersList);
  }
}

class CreateNewGroupUsecasePrams {
  MyChatEntity myChatEntity;
  List<String> selectedUsersList;
  CreateNewGroupUsecasePrams(
      {required this.myChatEntity, required this.selectedUsersList});
}
