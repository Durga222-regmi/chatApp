import 'package:group_chat_fb/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:group_chat_fb/core/use_case/usecase.dart';
import 'package:group_chat_fb/features/authentication/domain/enitity/user_entity.dart';

import '../repository/auth_repository.dart';

class GetCurrentCreateUserUsecase
    extends UseCase<void, GetCurrentCreateUserUsecaseParams> {
  final AuthRepository repository;
  GetCurrentCreateUserUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(
      GetCurrentCreateUserUsecaseParams params) async {
    return await repository.getCurrentCreateUser(params.user);
  }
}

class GetCurrentCreateUserUsecaseParams {
  UserEntity user;

  GetCurrentCreateUserUsecaseParams({required this.user});
}
