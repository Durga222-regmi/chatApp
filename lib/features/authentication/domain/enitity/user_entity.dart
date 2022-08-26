import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? name;
  final String? email;
  final String? phoneNumber;
  final bool? isOnline;
  final String? userId;
  final String? status;
  final String? profileUrl;
  final String? password;
  final Timestamp? dob;
  final String? gender;
  final List<String>? chattingWith;
  final String? pushToken;

  const UserEntity(
      {this.dob,
      this.email,
      this.gender,
      this.isOnline,
      this.name,
      this.password,
      this.phoneNumber,
      this.profileUrl,
      this.status,
      this.userId,
      this.chattingWith,
      this.pushToken});

  @override
  List<Object?> get props => [
        name,
        email,
        gender,
        isOnline,
        password,
        phoneNumber,
        profileUrl,
        status,
        userId,
        chattingWith,
        pushToken
      ];
}
