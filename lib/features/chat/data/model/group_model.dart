import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_chat_fb/features/chat/domain/entity/group_entity.dart';

class GroupModel extends GroupEntity {
  @override
  final String? groupName;
  @override
  final String? joinUsers;
  @override
  final String? groupProfileImage;
  @override
  final String? limitUsers;
  @override
  final Timestamp? creationTime;
  @override
  final String? groupId;
  @override
  final String? uid;
  @override
  final String? lastMessage;

  const GroupModel(
      {this.creationTime,
      this.groupId,
      this.groupName,
      this.groupProfileImage,
      this.joinUsers,
      this.lastMessage,
      this.limitUsers,
      this.uid})
      : super(
          creationTime: creationTime,
          groupId: groupId,
          groupName: groupName,
          groupProfileImage: groupProfileImage,
          joinUsers: joinUsers,
          lastMessage: lastMessage,
          limitUsers: limitUsers,
          uid: uid,
        );

  factory GroupModel.fromSnapshot(DocumentSnapshot snapshot) {
    return GroupModel(
      groupName: snapshot.get('groupName'),
      creationTime: snapshot.get('creationTime'),
      groupId: snapshot.get('groupId'),
      groupProfileImage: snapshot.get('groupProfileImage'),
      joinUsers: snapshot.get('joinUsers'),
      limitUsers: snapshot.get('limitUsers'),
      lastMessage: snapshot.get('lastMessage'),
      uid: snapshot.get('uid'),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "groupName": groupName,
      "creationTime": creationTime,
      "groupId": groupId,
      "groupProfileImage": groupProfileImage,
      "joinUsers": joinUsers,
      "limitUsers": limitUsers,
      "lastMessage": lastMessage,
      "uid": uid,
    };
  }
}
