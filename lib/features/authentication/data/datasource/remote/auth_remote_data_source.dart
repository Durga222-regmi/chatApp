import 'package:group_chat_fb/features/authentication/domain/enitity/user_entity.dart';

abstract class AuthRemoteDataSource {
  Future<void> verifyPhoneNumber(String phoneNumber);
  Future<void> getCurrentCreateUser(UserEntity entity);
  Future<void> signInWithPhoneNumber(String phoneNumber);
  Future<void> googleAuth();
  Future<void> forgotPassword(String email);
  Future<bool> isSignIn();
  Future<void> signUp(UserEntity user);
  Future<void> getUpdateUser(UserEntity model);
  Future<String> getCurrentUserId();
  Stream<List<UserEntity>> getAllUsers();

  Future<void> signOut();
  Future<void> signIn(UserEntity userEntity);
}
