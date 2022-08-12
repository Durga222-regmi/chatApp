import 'package:dartz/dartz.dart';
import 'package:group_chat_fb/core/error/failure.dart';
import 'package:group_chat_fb/core/use_case/usecase.dart';
import 'package:group_chat_fb/features/chat/domain/entity/my_chat_entity.dart';
import 'package:group_chat_fb/features/chat/domain/repository/chat_repository.dart';

class CreateNewGroupUsecase extends UseCase<void, CreateNewGroupUsecasePrams> {
  final ChatRepository repository;
  CreateNewGroupUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(CreateNewGroupUsecasePrams params) async {
    return await repository.createNewGroup(
        params.myChatEntity, params.selectedUsersList);
  }
}

class CreateNewGroupUsecasePrams {
  MyChatEntity myChatEntity;
  List<String> selectedUsersList;
  CreateNewGroupUsecasePrams(
      {required this.myChatEntity, required this.selectedUsersList});
}
