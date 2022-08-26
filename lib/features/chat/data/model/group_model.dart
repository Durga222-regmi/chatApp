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
  final String? lastMessage;
  @override
  final GroupAdminModel? admin;
  @override
  final List<GroupUserModel>? users;

  const GroupModel(
      {this.creationTime,
      this.groupId,
      this.groupName,
      this.groupProfileImage,
      this.joinUsers,
      this.lastMessage,
      this.limitUsers,
      this.admin,
      this.users})
      : super(
          creationTime: creationTime,
          groupId: groupId,
          groupName: groupName,
          groupProfileImage: groupProfileImage,
          joinUsers: joinUsers,
          lastMessage: lastMessage,
          limitUsers: limitUsers,
          admin: admin,
        );

  factory GroupModel.fromSnapshot(DocumentSnapshot snapshot) {
    List<dynamic> groupUserList = snapshot.get("users");

    List<GroupUserModel> groupUserModel =
        groupUserList.map((e) => GroupUserModel.formDocument(e)).toList();

    return GroupModel(
        groupName: snapshot.get('groupName'),
        creationTime: snapshot.get('creationTime'),
        groupId: snapshot.get('groupId'),
        groupProfileImage: snapshot.get('groupProfileImage'),
        joinUsers: snapshot.get('joinUsers').toString(),
        limitUsers: snapshot.get('limitUsers'),
        lastMessage: snapshot.get('lastMessage'),
        admin: GroupAdminModel.formDocument(snapshot.get('admin')),
        users: groupUserModel);
  }

  Map<String, dynamic> toDocument() {
    List<Map<String, dynamic>> map = [];
    for (var i in users!) {
      map.add({"uid": i.uid, "name": i.name, "profileUrl": i.profileUrl});
    }

    return {
      "groupName": groupName,
      "creationTime": creationTime,
      "groupId": groupId,
      "groupProfileImage": groupProfileImage,
      "joinUsers": joinUsers,
      "limitUsers": limitUsers,
      "lastMessage": lastMessage,
      "admin": {
        "name": admin!.name,
        "uid": admin!.uid,
        "profileUrl": admin!.profileUrl
      },
      "users": map
    };
  }
}

class GroupUserModel extends GroupUserEntity {
  GroupUserModel({required super.uid, super.name, super.profileUrl});

  factory GroupUserModel.formDocument(Map map) {
    return GroupUserModel(
        uid: map["uid"], name: map["name"], profileUrl: map["profileUrl"]);
  }

  Map<String, dynamic> toDocument() {
    return {"uid": uid, "name": name, "profileUrl": profileUrl};
  }
}

class GroupAdminModel extends GroupAdminEntity {
  GroupAdminModel({required super.uid, super.name, super.profileUrl});

  factory GroupAdminModel.formDocument(Map map) {
    return GroupAdminModel(
        uid: map["uid"], name: map["name"], profileUrl: map["profileUrl"]);
  }

  Map<String, dynamic> toDocument() {
    return {"uid": uid, "name": name, "profileUrl": profileUrl};
  }
}
