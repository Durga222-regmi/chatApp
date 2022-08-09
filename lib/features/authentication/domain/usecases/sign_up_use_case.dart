import 'package:group_chat_fb/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:group_chat_fb/core/use_case/usecase.dart';
import 'package:group_chat_fb/features/authentication/domain/enitity/user_entity.dart';

import '../repository/auth_repository.dart';

class SignUpUsecase extends UseCase<void, SignUpUsecasePrams> {
  final AuthRepository repository;
  SignUpUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(SignUpUsecasePrams params) async {
    return await repository.signUp(params.entity);
  }
}

class SignUpUsecasePrams {
  UserEntity entity;
  SignUpUsecasePrams({required this.entity});
}
