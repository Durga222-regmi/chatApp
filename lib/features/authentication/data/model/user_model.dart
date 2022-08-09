import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_chat_fb/features/authentication/domain/enitity/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    final String? name,
    final String? email,
    final String? phoneNumber,
    final bool? isOnline,
    final String? userId,
    final String? status,
    final String? profileUrl,
    final String? password,
    final Timestamp? dob,
    final String? gender,
  }) : super(
            name: name,
            email: email,
            phoneNumber: phoneNumber,
            isOnline: isOnline,
            userId: userId,
            status: status,
            profileUrl: profileUrl,
            password: password,
            dob: dob,
            gender: gender);

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
        name: doc["name"],
        dob: doc["dob"],
        email: doc["email"],
        password: doc["password"],
        gender: doc["gender"],
        isOnline: doc["isOnline"],
        phoneNumber: doc["phoneNumber"],
        profileUrl: doc["profileUrl"],
        status: doc["status"],
        userId: doc["userId"]);
  }

  Map<String, dynamic> toDocument() {
    return {
      "name": name,
      "dob": dob,
      "email": email,
      "password": password,
      "gender": gender,
      "isOnline": isOnline,
      "phoneNumber": phoneNumber,
      "profileUrl": profileUrl,
      "status": status,
      "userId": userId,
    };
  }
}
