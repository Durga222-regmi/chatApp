import 'package:dartz/dartz.dart';
import 'package:group_chat_fb/core/error/failure.dart';
import 'package:group_chat_fb/core/use_case/usecase.dart';

import '../repository/auth_repository.dart';

class ForgotPasswordUsecase extends UseCase<void, ForgotPasswordParams> {
  final AuthRepository repository;
  ForgotPasswordUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(ForgotPasswordParams params) async {
    return await repository.forgotPassword(params.email);
  }
}

class ForgotPasswordParams extends Params {
  String email;

  ForgotPasswordParams({required this.email});
}
