import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MyChatEntity extends Equatable {
  final String? senderName;
  final String? channelId;
  final String? recipientName;
  final String? senderUID;
  final String? recipientUID;
  final String? profileUrl;
  final String? recentTextMessage;
  final bool? isRead;
  final Timestamp? time;
  final bool? isArchived;
  final String? recipientPhoneNumber;
  final String? senderPhoneNumber;
  final String? subjectName;
  final String? communicationType;

  const MyChatEntity({
    this.channelId,
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
    this.time,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        senderName,
        channelId,
        recipientName,
        senderUID,
        profileUrl,
        recentTextMessage,
        isRead,
        time,
        isArchived,
        recipientPhoneNumber,
        senderPhoneNumber,
        subjectName,
        communicationType,
        recipientUID
      ];
}
