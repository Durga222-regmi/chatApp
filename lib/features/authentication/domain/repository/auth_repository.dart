import 'package:dartz/dartz.dart';
import 'package:group_chat_fb/core/error/failure.dart';
import 'package:group_chat_fb/core/type_def/type_def_constant.dart';
import 'package:group_chat_fb/features/authentication/domain/enitity/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> getCurrentCreateUser(UserEntity entity);
  Future<Either<Failure, void>> googleAuth();
  Future<Either<Failure, void>> forgotPassword(String email);
  Future<Either<Failure, bool>> isSignIn();
  Future<Either<Failure, void>> signUp(UserEntity user);
  Future<Either<Failure, void>> getUpdateUser(UserEntity userEntity);
  Future<Either<Failure, String>> getCurrentUserId();
  Future<Either<Failure, StreamList<UserEntity>>> getAllUsers();
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, void>> signIn(UserEntity user);
}
