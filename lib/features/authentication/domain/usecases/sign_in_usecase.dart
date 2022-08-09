import 'package:group_chat_fb/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:group_chat_fb/core/use_case/usecase.dart';
import 'package:group_chat_fb/features/authentication/domain/enitity/user_entity.dart';

import '../repository/auth_repository.dart';

class SignInUsecase extends UseCase<void, SignInUsecasePrams> {
  final AuthRepository repository;
  SignInUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(SignInUsecasePrams params) async {
    return await repository.signIn(params.entity);
  }
}

class SignInUsecasePrams {
  UserEntity entity;
  SignInUsecasePrams({required this.entity});
}
