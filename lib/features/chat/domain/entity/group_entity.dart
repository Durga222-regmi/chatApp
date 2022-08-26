import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class GroupEntity extends Equatable {
  final String? groupName;
  final String? joinUsers;
  final String? groupProfileImage;
  final String? limitUsers;
  final Timestamp? creationTime;
  final String? groupId;
  final GroupAdminEntity? admin;
  final String? lastMessage;
  final String? uid;

  final List<GroupUserEntity>? users;

  const GroupEntity({
    this.creationTime,
    this.groupId,
    this.groupName,
    this.groupProfileImage,
    this.joinUsers,
    this.lastMessage,
    this.limitUsers,
    this.users,
    this.admin,
    this.uid,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        groupName,
        joinUsers,
        groupProfileImage,
        limitUsers,
        creationTime,
        groupId,
        admin,
        lastMessage,
        users,
        admin,
        uid
      ];
}

class GroupUserEntity {
  String? uid;
  String? name;
  String? profileUrl;

  GroupUserEntity({required this.uid, this.name, this.profileUrl});
}

class GroupAdminEntity {
  String? uid;
  String? name;
  String? profileUrl;
  GroupAdminEntity({this.name, required this.uid, this.profileUrl});
}
