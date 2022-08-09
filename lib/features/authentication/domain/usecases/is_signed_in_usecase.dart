import 'package:group_chat_fb/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:group_chat_fb/core/use_case/usecase.dart';

import '../repository/auth_repository.dart';

class IsSignedInUsecase extends UseCase<bool, NoParams> {
  final AuthRepository repository;
  IsSignedInUsecase({required this.repository});

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return repository.isSignIn();
  }
}
