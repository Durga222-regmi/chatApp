import 'package:group_chat_fb/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:group_chat_fb/core/use_case/usecase.dart';
import 'package:group_chat_fb/features/authentication/domain/repository/auth_repository.dart';

class UpdateChattingWithUsecase
    extends UseCase<void, UpdateChattingWithUsecaseParams> {
  AuthRepository repository;
  UpdateChattingWithUsecase({required this.repository});
  @override
  Future<Either<Failure, void>> call(
      UpdateChattingWithUsecaseParams params) async {
    return await repository.updateChattingWith(params.users, params.uid);
  }
}

class UpdateChattingWithUsecaseParams {
  List<String> users;
  String uid;
  UpdateChattingWithUsecaseParams({required this.uid, required this.users});
}
