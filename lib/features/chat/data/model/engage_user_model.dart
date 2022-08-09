import 'package:group_chat_fb/features/chat/domain/entity/engage_user_entity.dart';

class EngageUserModel extends EngageUserEntity {
  final String? uid;
  final String? otherUid;
  EngageUserModel({this.otherUid, this.uid})
      : super(otherUid: otherUid, uid: uid);
}
