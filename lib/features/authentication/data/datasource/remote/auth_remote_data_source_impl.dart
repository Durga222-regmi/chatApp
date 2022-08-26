// ignore_for_file: prefer_function_declarations_over_variables

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:group_chat_fb/features/authentication/data/datasource/remote/auth_remote_data_source.dart';
import 'package:group_chat_fb/features/authentication/data/model/user_model.dart';
import 'package:group_chat_fb/features/authentication/domain/enitity/user_entity.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  FirebaseAuth firebaseAuth;
  FirebaseFirestore firebaseFirestore;
  final GoogleSignIn gSignIn;
  String _verificationId = "";
  AuthRemoteDataSourceImpl(
      {required this.firebaseAuth,
      required this.firebaseFirestore,
      required this.gSignIn});

  @override
  Future<void> forgotPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Stream<List<UserEntity>> getAllUsers() {
    final userCollection = firebaseFirestore.collection("users");
    return userCollection.snapshots().map(
        (event) => event.docs.map((e) => UserModel.fromDocument(e)).toList());
  }

  @override
  Future<void> getCurrentCreateUser(UserEntity entity) async {
    final userCollection = firebaseFirestore.collection("users");
    final uid = await getCurrentUserId();
    userCollection.doc(uid).get().then((firestoreUser) {
      final user = UserModel(
              name: entity.name,
              email: entity.email,
              dob: entity.dob,
              gender: entity.gender,
              isOnline: entity.isOnline,
              phoneNumber: entity.phoneNumber,
              profileUrl: entity.profileUrl,
              status: entity.status,
              userId: uid,
              chattingWith: entity.chattingWith)
          .toDocument();

      if (!firestoreUser.exists) {
        userCollection.doc(uid).set(user);
        return;
      } else {
        userCollection.doc(uid).update(user);
        log("user already exists");
        return;
      }
    });
  }

  @override
  Future<void> updateChattingWith(List<String>? users, String uid) async {
    final userDoc = await firebaseFirestore.collection("users").doc(uid).get();
    if (users == null || users == []) {
      await userDoc.reference.update({"chattingWith": null});
    } else {
      await userDoc.reference.update({"chattingWith": users});
    }
  }

  @override
  Future<String> getCurrentUserId() async {
    return firebaseAuth.currentUser!.uid;
  }

  @override
  Future<void> getUpdateUser(UserEntity user) async {
    final userCollection = firebaseFirestore.collection("users");
    Map<String, dynamic> userInformation = {};
    if (user.profileUrl != null && user.profileUrl != "") {
      userInformation['profileUrl'] = user.profileUrl;
    }
    if (user.status != null && user.status != "") {
      userInformation['status'] = user.status;
    }
    if (user.phoneNumber != null && user.phoneNumber != "") {
      userInformation["phoneNumber"] = user.phoneNumber;
    }
    if (user.name != null && user.name != "") {
      userInformation["name"] = user.name;
    }

    userCollection.doc(user.userId).update(userInformation);
  }

  @override
  Future<void> googleAuth() async {
    final userCollection = firebaseFirestore.collection("users");

    try {
      final GoogleSignInAccount? account = await gSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await account!.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      final information =
          (await firebaseAuth.signInWithCredential(credential)).user;
      userCollection
          .doc(firebaseAuth.currentUser?.uid)
          .get()
          .then((gUser) async {
        if (!gUser.exists) {
          final user = UserModel(
            email: information!.email,
            name: information.displayName,
            phoneNumber: information.phoneNumber ?? "",
            profileUrl: information.photoURL ?? "",
            userId: information.uid,
          ).toDocument();

          await userCollection.doc(firebaseAuth.currentUser?.uid).set(user);
        }
      }).whenComplete(() => log("new user created success fully"));
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<bool> isSignIn() async {
    return firebaseAuth.currentUser?.uid != null;
  }

  @override
  Future<void> signUp(UserEntity user) async {
    await firebaseAuth.createUserWithEmailAndPassword(
        email: user.email!, password: user.password!);
  }

  @override
  Future<void> signInWithPhoneNumber(String pinCode) async {
    final AuthCredential authCredential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: pinCode);
    await firebaseAuth.signInWithCredential(authCredential);
  }

  @override
  Future<void> verifyPhoneNumber(String phoneNumber) async {
    final PhoneVerificationCompleted phoneVerificationCompleted =
        (AuthCredential credential) {
      log("phone is verified,token is:${credential.token}");
    };

    final PhoneVerificationFailed phoneVerificationFailed =
        (FirebaseAuthException exp) {
      log("cant verified");
    };
    PhoneCodeSent phoneCodeSent =
        (String verificationID, [int? forceResendingToken]) {
      _verificationId = verificationID;
      print("sendPhoneCode $verificationID");
    };
    final codeAuthRetrievalTimeout = (String verificationId) {
      _verificationId = verificationId;
      log("time out $verificationId");
    };
    await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: phoneVerificationCompleted,
        verificationFailed: phoneVerificationFailed,
        codeSent: phoneCodeSent,
        codeAutoRetrievalTimeout: codeAuthRetrievalTimeout);
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
    await gSignIn.signOut();
  }

  @override
  Future<void> signIn(UserEntity userEntity) async {
    await firebaseAuth.signInWithEmailAndPassword(
        email: userEntity.email!, password: userEntity.password!);
  }
}
