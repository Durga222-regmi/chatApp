import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_chat_fb/features/chat/domain/entity/my_chat_entity.dart';

class MyChatModel extends MyChatEntity {
  final String? senderName;
  final String? channelId;
  final String? recipientName;
  final String? senderUID;
  final String? profileUrl;
  final String? recentTextMessage;
  final bool? isRead;
  final String? recipientUID;
  final Timestamp? time;
  final bool? isArchived;
  final String? recipientPhoneNumber;
  final String? senderPhoneNumber;
  final String? subjectName;
  final String? communicationType;
  MyChatModel(
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
            time: time);

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
      "communicationType": communicationType
    };
  }
}
