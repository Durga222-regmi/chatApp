import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TextMessageEntity extends Equatable {
  final String? recipientId;
  final String? senderId;
  final String? senderName;
  final String? type;
  final Timestamp? time;
  final String? status;
  final String? content;
  final String? receiverName;
  final String? messageId;

  TextMessageEntity(
      {this.content,
      this.messageId,
      this.receiverName,
      this.recipientId,
      this.senderId,
      this.senderName,
      this.time,
      this.status,
      this.type});

  @override
  // TODO: implement props
  List<Object?> get props => [
        receiverName,
        senderId,
        recipientId,
        senderName,
        type,
        time,
        content,
        status,
        receiverName,
        messageId
      ];
}
