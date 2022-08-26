import 'package:equatable/equatable.dart';

class SingleChatEntity extends Equatable {
  final String? groupId;
  final String? groupName;
  final String? uid;
  final String? userName;
  final String? photoUrl;
  final List<String>? userList;

  const SingleChatEntity(
      {this.groupId,
      this.groupName,
      this.uid,
      this.userName,
      this.photoUrl,
      this.userList});

  @override
  // TODO: implement props
  List<Object?> get props => [groupId, groupName, uid, userName, photoUrl];
}
