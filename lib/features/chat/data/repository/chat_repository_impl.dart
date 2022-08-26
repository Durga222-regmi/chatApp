import 'package:dartz/dartz.dart';
import 'package:group_chat_fb/core/enum/enums.dart';
import 'package:group_chat_fb/core/error/failure.dart';
import 'package:group_chat_fb/core/type_def/type_def_constant.dart';
import 'package:group_chat_fb/features/chat/domain/entity/engage_user_entity.dart';
import 'package:group_chat_fb/features/chat/domain/entity/group_entity.dart';
import 'package:group_chat_fb/features/chat/domain/entity/my_chat_entity.dart';
import 'package:group_chat_fb/features/chat/domain/entity/text_message_entity.dart';
import 'package:group_chat_fb/features/chat/domain/repository/chat_repository.dart';

import '../datasources/remote_data_source/chat_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRemoteDataSource chatRemoteDataSource;

  ChatRepositoryImpl({required this.chatRemoteDataSource});

  @override
  Future<Either<Failure, void>> addToMyChat(MyChatEntity myChatEntity) async {
    try {
      return Right(await chatRemoteDataSource.addToMyChat(myChatEntity));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> createNewGroup(
      MyChatEntity myChatEntity, List<String> selectedUsersList) async {
    try {
      return Right(await chatRemoteDataSource.createNewGroup(
          myChatEntity, selectedUsersList));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> createOneToOneChannel(
      EngageUserEntity engageUserEntity) async {
    try {
      return Right(
          await chatRemoteDataSource.createOneToOneChannel(engageUserEntity));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> getChannelId(
      EngageUserEntity engageUserEntity) async {
    try {
      return Right(await chatRemoteDataSource.getChannelId(engageUserEntity));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> getCreateGroup(GroupEntity groupEntity) async {
    try {
      return Right(await chatRemoteDataSource
          .getCreateGroup(groupEntity)
          .timeout(const Duration(seconds: 5)));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, StreamList<GroupEntity>>> getGroups() async {
    try {
      return Right(chatRemoteDataSource.getGroups());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, StreamList<MyChatEntity>>> getMyChat(
      String uid) async {
    try {
      return Right(chatRemoteDataSource.getMyChat(uid));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, StreamList<TextMessageEntity>>> getTextMessages(
    MessageType messageType,
    String channelId,
  ) async {
    try {
      return Right(
          chatRemoteDataSource.getTextMessages(channelId, messageType));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> joinGroup(
      GroupEntity groupEntity, String uid) async {
    try {
      return Right(await chatRemoteDataSource.joinGroup(groupEntity, uid));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> sendTextMessage(
      TextMessageEntity textMessageEntity,
      String channelID,
      MessageType messageType) async {
    try {
      return Right(await chatRemoteDataSource.sendTextMessage(
          textMessageEntity, channelID, messageType));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateGroup(GroupEntity groupEntity) async {
    try {
      return Right(await chatRemoteDataSource.updateGroup(groupEntity));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, GroupEntity>> getSingleGroupDetail(
      String groupId) async {
    try {
      return Right(await chatRemoteDataSource.getSingleGroupDetail(groupId));
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
