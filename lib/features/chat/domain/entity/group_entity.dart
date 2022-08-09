import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class GroupEntity extends Equatable {
  final String? groupName;
  final String? joinUsers;
  final String? groupProfileImage;
  final String? limitUsers;
  final Timestamp? creationTime;
  final String? groupId;
  final String? uid;
  final String? lastMessage;

  const GroupEntity({
    this.creationTime,
    this.groupId,
    this.groupName,
    this.groupProfileImage,
    this.joinUsers,
    this.lastMessage,
    this.limitUsers,
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
        uid,
        lastMessage
      ];
}
