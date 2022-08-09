import 'package:dartz/dartz.dart';
import 'package:group_chat_fb/core/error/failure.dart';
import 'package:group_chat_fb/core/use_case/usecase.dart';
import 'package:group_chat_fb/features/chat/domain/entity/my_chat_entity.dart';
import 'package:group_chat_fb/features/chat/domain/repository/chat_repository.dart';

class AddToMyChatUseCase extends UseCase<void, AddToMyChatUseCasePrams> {
  final ChatRepository repository;
  AddToMyChatUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(AddToMyChatUseCasePrams params) async {
    return await repository.addToMyChat(params.myChatEntity);
  }
}

class AddToMyChatUseCasePrams {
  MyChatEntity myChatEntity;
  AddToMyChatUseCasePrams({required this.myChatEntity});
}
