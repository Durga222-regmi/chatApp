import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_chat_fb/features/chat/domain/entity/text_message_entity.dart';

class TextMessageModel extends TextMessageEntity {
  @override
  final String? recipientId;
  @override
  final String? senderId;
  @override
  final String? senderName;
  @override
  final String? type;
  @override
  final Timestamp? time;
  @override
  final String? content;
  @override
  final String? receiverName;
  @override
  final String? messageId;
  @override
  final String? status;

  TextMessageModel(
      {this.content,
      this.messageId,
      this.receiverName,
      this.recipientId,
      this.senderId,
      this.senderName,
      this.time,
      this.status,
      this.type})
      : super(
            content: content,
            messageId: messageId,
            receiverName: receiverName,
            recipientId: recipientId,
            senderId: senderId,
            senderName: senderName,
            time: time,
            status: status,
            type: type);
  factory TextMessageModel.fromSnapshot(DocumentSnapshot snapshot) {
    return TextMessageModel(
      recipientId: snapshot.get('recipientId'),
      senderId: snapshot.get('senderId'),
      senderName: snapshot.get('senderName'),
      type: snapshot.get('type'),
      time: snapshot.get('time'),
      status: snapshot.get('status') ?? "NA",
      content: snapshot.get('content'),
      receiverName: snapshot.get('receiverName'),
      messageId: snapshot.get('messageId'),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "recipientId": recipientId,
      "senderId": senderId,
      "senderName": senderName,
      "status": status,
      "type": type,
      "time": time,
      "content": content,
      "receiverName": receiverName,
      "messageId": messageId,
    };
  }
}
