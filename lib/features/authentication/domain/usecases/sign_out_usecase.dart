import 'package:group_chat_fb/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:group_chat_fb/core/use_case/usecase.dart';

import '../repository/auth_repository.dart';

class SignOutUseCase extends UseCase<void, NoParams> {
  final AuthRepository repository;
  SignOutUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.signOut();
  }
}
