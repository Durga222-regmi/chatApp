import 'package:dartz/dartz.dart';
import 'package:group_chat_fb/core/error/failure.dart';
import 'package:group_chat_fb/core/type_def/type_def_constant.dart';
import 'package:group_chat_fb/features/authentication/data/datasource/remote/auth_remote_data_source.dart';
import 'package:group_chat_fb/features/authentication/domain/enitity/user_entity.dart';
import 'package:group_chat_fb/features/authentication/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRemoteDataSource remoteDataSource;
  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    try {
      return Right(await remoteDataSource.forgotPassword(email));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, StreamList<UserEntity>>> getAllUsers() async {
    try {
      return Right(remoteDataSource.getAllUsers());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> getCurrentCreateUser(UserEntity entity) async {
    try {
      return Right(await remoteDataSource.getCurrentCreateUser(entity));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> getCurrentUserId() async {
    try {
      return Right(await remoteDataSource.getCurrentUserId());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> getUpdateUser(UserEntity userEntity) async {
    try {
      return Right(await remoteDataSource.getUpdateUser(userEntity));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> googleAuth() async {
    try {
      return Right(await remoteDataSource.googleAuth());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isSignIn() async {
    try {
      return Right(await remoteDataSource.isSignIn());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> signIn(UserEntity user) async {
    try {
      return Right(await remoteDataSource.signIn(user));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      return Right(await remoteDataSource.signOut());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> signUp(UserEntity user) async {
    try {
      return Right(await remoteDataSource.signUp(user));
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
