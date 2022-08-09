import 'package:group_chat_fb/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:group_chat_fb/core/use_case/usecase.dart';
import 'package:group_chat_fb/features/authentication/domain/enitity/user_entity.dart';

import '../repository/auth_repository.dart';

class GetAllUserUsecase extends UseCase<Stream<List<UserEntity>>, NoParams> {
  final AuthRepository repository;
  GetAllUserUsecase({required this.repository});

  @override
  Future<Either<Failure, Stream<List<UserEntity>>>> call(NoParams params) {
    return repository.getAllUsers();
  }
}
