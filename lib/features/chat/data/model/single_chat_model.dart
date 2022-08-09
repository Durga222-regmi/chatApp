import 'package:group_chat_fb/features/chat/domain/entity/single_chat_entity.dart';

class SingleChatModel extends SingleChatEntity {
  final String? groupId;
  final String? groupName;
  final String? uid;
  final String? userName;
  SingleChatModel({this.groupId, this.groupName, this.uid, this.userName})
      : super(
            groupId: groupId,
            groupName: groupName,
            uid: uid,
            userName: userName);
}
