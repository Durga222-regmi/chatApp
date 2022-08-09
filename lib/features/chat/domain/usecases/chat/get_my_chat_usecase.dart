import 'package:group_chat_fb/core/type_def/type_def_constant.dart';
import 'package:group_chat_fb/core/use_case/usecase.dart';
import 'package:group_chat_fb/features/chat/domain/entity/my_chat_entity.dart';
import 'package:group_chat_fb/features/chat/domain/repository/chat_repository.dart';

class GetMyChatUsecase
    extends UseCase<StreamList<MyChatEntity>, GetMyChatUsecaseParams> {
  final ChatRepository repository;
  GetMyChatUsecase({required this.repository});

  @override
  StreamList<MyChatEntity> call(GetMyChatUsecaseParams params) {
    return repository.getMyChat(params.uid);
  }
}

class GetMyChatUsecaseParams {
  String uid;
  GetMyChatUsecaseParams({required this.uid});
}
