import 'package:pigu/app/core/models/user_model.dart';

abstract class UserRepositoryInterface {
  Stream<List<UserModel>> getUsers();
  Future changePassword(String userPassword);
  Future changeEmail(String userPassword);
  Future getUser(String userId);
  Future recoveryPassword(String email);
  Future updateUserPhoto(String userPhoto, String userId);
  Future updateUser(UserModel userM);
  Future setAddress(Map<String, dynamic> address, String userId);
  Future getAdress(String userId);
}
