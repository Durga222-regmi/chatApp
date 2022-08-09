import 'package:group_chat_fb/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:group_chat_fb/core/use_case/usecase.dart';
import 'package:group_chat_fb/features/authentication/domain/enitity/user_entity.dart';

import '../repository/auth_repository.dart';

class GetUpdateUserUsecase extends UseCase<void, GetUpdateUserUsecasePrams> {
  final AuthRepository repository;
  GetUpdateUserUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(GetUpdateUserUsecasePrams params) async {
    return await repository.getUpdateUser(params.entity);
  }
}

class GetUpdateUserUsecasePrams {
  UserEntity entity;
  GetUpdateUserUsecasePrams({required this.entity});
}
