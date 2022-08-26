import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_chat_fb/features/chat/domain/entity/my_chat_entity.dart';

class MyChatModel extends MyChatEntity {
  @override
  final String? senderName;
  @override
  final String? channelId;
  @override
  final String? recipientName;
  @override
  final String? senderUID;
  @override
  final String? profileUrl;
  @override
  final String? recentTextMessage;
  @override
  final bool? isRead;
  @override
  final String? recipientUID;
  @override
  final Timestamp? time;
  @override
  final bool? isArchived;
  @override
  final String? recipientPhoneNumber;
  @override
  final String? senderPhoneNumber;
  @override
  final String? subjectName;
  @override
  final String? communicationType;
  @override
  final bool? isGroup;
  const MyChatModel(
      {this.channelId,
      this.communicationType,
      this.isArchived,
      this.recipientUID,
      this.isRead,
      this.profileUrl,
      this.recentTextMessage,
      this.recipientName,
      this.recipientPhoneNumber,
      this.senderName,
      this.senderPhoneNumber,
      this.senderUID,
      this.subjectName,
      this.isGroup,
      this.time})
      : super(
            senderName: senderName,
            channelId: channelId,
            communicationType: communicationType,
            isArchived: isArchived,
            isRead: isRead,
            profileUrl: profileUrl,
            recentTextMessage: recentTextMessage,
            recipientName: recipientName,
            recipientPhoneNumber: recipientPhoneNumber,
            senderPhoneNumber: senderPhoneNumber,
            senderUID: senderUID,
            recipientUID: recipientUID,
            subjectName: subjectName,
            time: time,
            isGroup: isGroup);

  factory MyChatModel.fromSnapshot(DocumentSnapshot snapshot) {
    return MyChatModel(
      senderName: snapshot.get('senderName'),
      recipientName: snapshot.get('recipientName'),
      channelId: snapshot.get('channelId'),
      recipientUID: snapshot.get('recipientUID'),
      senderUID: snapshot.get('senderUID'),
      profileUrl: snapshot.get('profileUrl'),
      recentTextMessage: snapshot.get('recentTextMessage'),
      isRead: snapshot.get('isRead'),
      time: snapshot.get('time'),
      isArchived: snapshot.get('isArchived'),
      recipientPhoneNumber: snapshot.get('recipientPhoneNumber'),
      senderPhoneNumber: snapshot.get('senderPhoneNumber'),
      subjectName: snapshot.get('subjectName'),
      communicationType: snapshot.get('communicationType'),
      isGroup: snapshot.get("isGroup") ?? false,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "senderName": senderName,
      "recipientName": recipientName,
      "channelId": channelId,
      "recipientUID": recipientUID,
      "senderUID": senderUID,
      "profileUrl": profileUrl,
      "recentTextMessage": recentTextMessage,
      "isRead": isRead,
      "time": time,
      "isArchived": isArchived,
      "recipientPhoneNumber": recipientPhoneNumber,
      "senderPhoneNumber": senderPhoneNumber,
      "subjectName": subjectName,
      "communicationType": communicationType,
      "isGroup": isGroup
    };
  }
}
