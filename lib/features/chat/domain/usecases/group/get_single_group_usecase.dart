import 'package:dartz/dartz.dart';
import 'package:group_chat_fb/core/error/failure.dart';
import 'package:group_chat_fb/core/use_case/usecase.dart';
import 'package:group_chat_fb/features/chat/domain/entity/group_entity.dart';
import 'package:group_chat_fb/features/chat/domain/repository/chat_repository.dart';

class GetSingleGroupUsecase
    extends UseCase<GroupEntity, GetSingleGroupUsecaseParams> {
  final ChatRepository repository;
  GetSingleGroupUsecase({required this.repository});

  @override
  Future<Either<Failure, GroupEntity>> call(
      GetSingleGroupUsecaseParams params) async {
    return await repository.getSingleGroupDetail(params.uid);
  }
}

class GetSingleGroupUsecaseParams {
  String uid;
  GetSingleGroupUsecaseParams({required this.uid});
}
