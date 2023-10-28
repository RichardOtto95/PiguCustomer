import 'package:pigu/app/core/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthServiceInterface {
  Future<FirebaseUser> handleGetUser();
  Future handleSetSignout();
  Future<String> handleGetToken();
  Future<FirebaseUser> handleGoogleSignin();
  Future<FirebaseUser> handleLinkAccountGoogle(FirebaseUser user);
  Future handleFacebookSignin();
  Future handleSignup(UserModel model);
  Future<FirebaseUser> handleEmailSignin(String userEmail, String userPassword);
  Future verifyNumber(String userPhone);
  Future handleSmsSignin(String smsCode, String verificationId);
}
