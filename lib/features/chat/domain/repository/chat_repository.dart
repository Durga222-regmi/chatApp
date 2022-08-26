import 'package:dartz/dartz.dart';
import 'package:group_chat_fb/core/enum/enums.dart';
import 'package:group_chat_fb/core/error/failure.dart';
import 'package:group_chat_fb/core/type_def/type_def_constant.dart';
import 'package:group_chat_fb/features/chat/domain/entity/engage_user_entity.dart';
import 'package:group_chat_fb/features/chat/domain/entity/group_entity.dart';
import 'package:group_chat_fb/features/chat/domain/entity/my_chat_entity.dart';
import 'package:group_chat_fb/features/chat/domain/entity/text_message_entity.dart';

abstract class ChatRepository {
  Future<Either<Failure, void>> getCreateGroup(GroupEntity groupEntity);
  Future<Either<Failure, StreamList<GroupEntity>>> getGroups();
  Future<Either<Failure, void>> joinGroup(GroupEntity groupEntity, String uid);
  Future<Either<Failure, void>> updateGroup(GroupEntity groupEntity);
  Future<Either<Failure, String>> createOneToOneChannel(
      EngageUserEntity engageUserEntity);
  Future<Either<Failure, String>> getChannelId(
      EngageUserEntity engageUserEntity);
  Future<Either<Failure, void>> createNewGroup(
      MyChatEntity myChatEntity, List<String> selectedUsersList);
  Future<Either<Failure, void>> sendTextMessage(
      TextMessageEntity textMessageEntity,
      String channelID,
      MessageType messageType);
  Future<Either<Failure, StreamList<TextMessageEntity>>> getTextMessages(
      MessageType messageType, String channelId);
  Future<Either<Failure, void>> addToMyChat(MyChatEntity myChatEntity);
  Future<Either<Failure, StreamList<MyChatEntity>>> getMyChat(String uid);
  Future<Either<Failure, GroupEntity>> getSingleGroupDetail(String groupId);
  // Future<Either<Failure, GroupEntity>> createVideoChatChanel(
  // //     String cahnnelId, List<GroupUserEntity> groupUserList);
  // // Future<Either<Failure, GroupEntity>> getVideoChatInfo(String uid);
}
