import 'package:group_chat_fb/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:group_chat_fb/core/use_case/usecase.dart';

import '../repository/auth_repository.dart';

class GetCurrentUserIdUsecase extends UseCase<String, NoParams> {
  final AuthRepository repository;
  GetCurrentUserIdUsecase({required this.repository});

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return repository.getCurrentUserId();
  }
}
