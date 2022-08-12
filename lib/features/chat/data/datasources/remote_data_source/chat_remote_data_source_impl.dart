import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:group_chat_fb/core/enum/enums.dart';
import 'package:group_chat_fb/features/chat/data/datasources/remote_data_source/chat_remote_data_source.dart';
import 'package:group_chat_fb/features/chat/data/model/group_model.dart';
import 'package:group_chat_fb/features/chat/data/model/my_chat_model.dart';
import 'package:group_chat_fb/features/chat/data/model/text_message_model.dart';
import 'package:group_chat_fb/features/chat/domain/entity/engage_user_entity.dart';
import 'package:group_chat_fb/features/chat/domain/entity/group_entity.dart';
import 'package:group_chat_fb/features/chat/domain/entity/my_chat_entity.dart';
import 'package:group_chat_fb/features/chat/domain/entity/text_message_entity.dart';

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  ChatRemoteDataSourceImpl(
      {required this.firebaseAuth, required this.firebaseFirestore});

  @override
  Future<void> addToMyChat(MyChatEntity myChatEntity) async {
    final myChatRef = firebaseFirestore
        .collection("users")
        .doc(myChatEntity.senderUID)
        .collection("myChat");

    final otherChatReference = firebaseFirestore
        .collection("users")
        .doc(myChatEntity.recipientUID)
        .collection("myChat");
    final myNewChatCurrentUser = MyChatModel(
      channelId: myChatEntity.channelId,
      senderName: myChatEntity.senderName,
      time: myChatEntity.time,
      recipientName: myChatEntity.recipientName,
      recipientPhoneNumber: myChatEntity.recipientPhoneNumber,
      isArchived: myChatEntity.isArchived,
      isRead: myChatEntity.isRead,
      profileUrl: myChatEntity.profileUrl,
      recentTextMessage: myChatEntity.recentTextMessage,
      recipientUID: myChatEntity.recipientUID,
      senderPhoneNumber: myChatEntity.senderPhoneNumber,
      subjectName: myChatEntity.subjectName,
      senderUID: myChatEntity.senderUID,
    ).toDocument();
    final myNewChatOtherUser = MyChatModel(
      channelId: myChatEntity.channelId,
      senderName: myChatEntity.senderName,
      time: myChatEntity.time,
      recipientName: myChatEntity.recipientName,
      recipientPhoneNumber: myChatEntity.recipientPhoneNumber,
      isArchived: myChatEntity.isArchived,
      isRead: myChatEntity.isRead,
      profileUrl: myChatEntity.profileUrl,
      recentTextMessage: myChatEntity.recentTextMessage,
      recipientUID: myChatEntity.recipientUID,
      senderPhoneNumber: myChatEntity.senderPhoneNumber,
      subjectName: myChatEntity.subjectName,
      senderUID: myChatEntity.senderUID,
    ).toDocument();

    myChatRef.doc(myChatEntity.recipientUID).get().then((myChatDoc) {
      if (!myChatDoc.exists) {
        myChatRef.doc(myChatEntity.recipientUID).set(myNewChatOtherUser);
        otherChatReference.doc(myChatEntity.senderUID).set(myNewChatOtherUser);
        return;
      } else {
        myChatRef.doc(myChatEntity.recipientUID).update(myNewChatCurrentUser);
        otherChatReference.doc(myChatEntity.senderUID).set(myNewChatOtherUser);
        return;
      }
    });
  }

  @override
  Future<void> createNewGroup(
      MyChatEntity myChatEntity, List<String> selectedUsersList) async {
    await _createGroup(myChatEntity, selectedUsersList);
    return;
  }

  @override
  Future<String> createOneToOneChannel(
      EngageUserEntity engageUserEntity) async {
    final userCollectionRef = firebaseFirestore.collection("users");
    final oneToOneChatChannelRef =
        firebaseFirestore.collection("oneToOneChatChannel");
    final chatDoc = await userCollectionRef
        .doc(engageUserEntity.uid)
        .collection("chatChannel")
        .doc(engageUserEntity.otherUid)
        .get();

    if (chatDoc.exists) {
      return chatDoc.get("channelId");
    } else {
      final chatChannelId = oneToOneChatChannelRef.doc().id;

      var channel = {'channelId': chatChannelId};

      await oneToOneChatChannelRef.doc(chatChannelId).set(channel);

      await userCollectionRef
          .doc(engageUserEntity.uid)
          .collection("chatChannel")
          .doc(engageUserEntity.otherUid)
          .set(channel);

      await userCollectionRef
          .doc(engageUserEntity.otherUid)
          .collection("chatChannel")
          .doc(engageUserEntity.uid)
          .set(channel);
      return chatChannelId;
    }
  }

  @override
  Future<String> getChannelId(EngageUserEntity engageUserEntity) {
    final userCollection = firebaseFirestore.collection("users");
    return userCollection
        .doc(engageUserEntity.uid)
        .collection("chatChannel")
        .doc(engageUserEntity.otherUid)
        .get()
        .then((chatChannel) {
      if (chatChannel.exists) {
        return chatChannel.get("channelId");
      } else {
        return Future.value("");
      }
    });
  }

  @override
  Future<void> getCreateGroup(GroupEntity groupEntity) async {
    final groupCollection = firebaseFirestore.collection("groups");
    final groupId = groupCollection.doc().id;
    groupCollection.doc(groupId).get().then((groupDoc) {
      final newGroup = GroupModel(
        groupId: groupId,
        creationTime: groupEntity.creationTime,
        groupName: groupEntity.groupName,
        joinUsers: groupEntity.joinUsers,
        groupProfileImage: groupEntity.groupProfileImage,
        lastMessage: groupEntity.lastMessage,
        limitUsers: groupEntity.limitUsers,
      ).toDocument();
      if (!groupDoc.exists) {
        groupCollection.doc(groupId).set(newGroup);
        return;
      }
      return;
    }).catchError((error) {
      log(error.toString());
    });
  }

  @override
  Stream<List<GroupEntity>> getGroups() {
    final groupCollection = firebaseFirestore.collection("groups");
    return groupCollection
        .orderBy("creationTime", descending: true)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((queryDoc) => GroupModel.fromSnapshot(queryDoc))
          .toList();
    });
  }

  @override
  Stream<List<MyChatEntity>> getMyChat(String uid) {
    final myChat =
        firebaseFirestore.collection("users").doc(uid).collection("myChat");
    return myChat
        .orderBy("time", descending: true)
        .snapshots()
        .map((qrySnapshot) {
      return qrySnapshot.docs.map((qryDocumentSnapshot) {
        return MyChatModel.fromSnapshot(qryDocumentSnapshot);
      }).toList();
    });
  }

  @override
  Stream<List<TextMessageEntity>> getTextMessages(
    String channelId,
    MessageType messageType,
  ) {
    final messageReference = _getMessageReference(messageType, channelId);
    return messageReference.orderBy("time").snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((queryDocumentSnapshot) {
        return TextMessageModel.fromSnapshot(queryDocumentSnapshot);
      }).toList();
    });
  }

  @override
  Future<void> joinGroup(GroupEntity groupEntity) async {
    final groupChannelCollection =
        firebaseFirestore.collection("groupChatChannel");

    groupChannelCollection.doc(groupEntity.groupId).get().then((groupChannel) {
      if (!groupChannel.exists) {
        final channelId = {"groupChannelId": groupEntity.groupId};
        groupChannelCollection.doc(groupEntity.groupId).set(channelId);
        return;
      }
      return;
    });
  }

  @override
  Future<void> sendTextMessage(TextMessageEntity textMessageEntity,
      String channelID, MessageType messageType) async {
    final messageReference = _getMessageReference(messageType, channelID);

    final messageId = messageReference.doc().id;

    log("the message id is:$messageId");

    final newMessage = TextMessageModel(
            content: textMessageEntity.content,
            receiverName: textMessageEntity.receiverName,
            senderName: textMessageEntity.senderName,
            recipientId: textMessageEntity.recipientId,
            senderId: textMessageEntity.senderId,
            time: textMessageEntity.time,
            type: textMessageEntity.type,
            messageId: messageId)
        .toDocument();
    await messageReference.doc(messageId).set(newMessage);
    log("sent");
  }

  @override
  Future<void> updateGroup(GroupEntity groupEntity) async {
    Map<String, dynamic> groupInformation = {};
    final userCollection = firebaseFirestore.collection("groups");

    if (groupEntity.groupProfileImage != null &&
        groupEntity.groupProfileImage != "") {
      groupInformation['groupProfileImage'] = groupEntity.groupProfileImage;
    }
    if (groupEntity.groupName != null && groupEntity.groupName != "") {
      groupInformation["groupName"] = groupEntity.groupName;
    }
    if (groupEntity.lastMessage != null && groupEntity.lastMessage != "") {
      groupInformation["lastMessage"] = groupEntity.lastMessage;
    }
    if (groupEntity.creationTime != null) {
      groupInformation["creationTime"] = groupEntity.creationTime;
    }

    await userCollection.doc(groupEntity.groupId).update(groupInformation);
  }

  _createGroup(
      MyChatEntity myChatEntity, List<String> selectedUsersList) async {
    final myNewChatCurrentUser = MyChatModel(
      channelId: myChatEntity.channelId,
      senderName: myChatEntity.senderName,
      time: myChatEntity.time,
      recipientName: myChatEntity.recipientName,
      recipientPhoneNumber: myChatEntity.recipientPhoneNumber,
      isArchived: myChatEntity.isArchived,
      isRead: myChatEntity.isRead,
      profileUrl: myChatEntity.profileUrl,
      recentTextMessage: myChatEntity.recentTextMessage,
      recipientUID: myChatEntity.recipientUID,
      senderPhoneNumber: myChatEntity.senderPhoneNumber,
      subjectName: myChatEntity.subjectName,
      senderUID: myChatEntity.senderUID,
    ).toDocument();

    await firebaseFirestore
        .collection("users")
        .doc(myChatEntity.senderUID)
        .collection("myChat")
        .doc(myChatEntity.channelId)
        .set(myNewChatCurrentUser)
        .then((value) {
      log("group created");
    }).catchError((error) {
      log("group creation error:$error");
    });
  }

  CollectionReference<Map<String, dynamic>> _getMessageReference(
      MessageType messageType, String channelId) {
    log("channelIdReadyToSent:$channelId");
    final messageReference = messageType == MessageType.group
        ? firebaseFirestore
            .collection("groupChatChannel")
            .doc(channelId)
            .collection("message")
        : firebaseFirestore
            .collection("oneToOneChatChannel")
            .doc(channelId)
            .collection("message");

    return messageReference;
  }
}
