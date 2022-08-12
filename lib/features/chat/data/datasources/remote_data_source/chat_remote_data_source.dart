import 'package:group_chat_fb/core/enum/enums.dart';

import '../../../domain/entity/engage_user_entity.dart';
import '../../../domain/entity/group_entity.dart';
import '../../../domain/entity/my_chat_entity.dart';
import '../../../domain/entity/text_message_entity.dart';

abstract class ChatRemoteDataSource {
  Future<void> getCreateGroup(GroupEntity groupEntity);
  Stream<List<GroupEntity>> getGroups();
  Future<void> joinGroup(GroupEntity groupEntity);
  Future<void> updateGroup(GroupEntity groupEntity);
  Future<String> createOneToOneChannel(EngageUserEntity engageUserEntity);
  Future<String> getChannelId(EngageUserEntity engageUserEntity);
  Future<void> createNewGroup(
      MyChatEntity myChatEntity, List<String> selectedUsersList);
  Future<void> sendTextMessage(TextMessageEntity textMessageEntity,
      String channelID, MessageType messageType);
  Stream<List<TextMessageEntity>> getTextMessages(
      String channelId, MessageType messageType);
  Future<void> addToMyChat(MyChatEntity myChatEntity);
  Stream<List<MyChatEntity>> getMyChat(String uid);
}
