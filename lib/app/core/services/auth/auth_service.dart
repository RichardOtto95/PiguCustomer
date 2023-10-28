import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pigu/app/core/models/user_model.dart';
import 'package:pigu/app/core/services/auth/auth_service_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthService implements AuthServiceInterface {
  // final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future handleFacebookSignin() {
    // TODO: implement handleFacebookSignin
    return null;
  }

  @override
  Future<String> handleGetToken() {
    // TODO: implement handleGetToken
    return null;
  }

  @override
  Future<FirebaseUser> handleGetUser() async {
    return _auth.currentUser();
  }

  @override
  Future<FirebaseUser> handleEmailSignin(
      String userEmail, String userPassword) async {
    AuthResult result = await _auth.signInWithEmailAndPassword(
        email: userEmail, password: userPassword);
    final FirebaseUser user = result.user;

    assert(user != null);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    //print'signInEmail succeeded: $user');

    return user;
  }

  @override
  Future handleSignup(UserModel model) async {
    FirebaseUser user = await _auth.currentUser();

    if (user != null) {
      model.id = user.uid;
      model.mobile_full_number = user.phoneNumber;
      model.status = 'active';
      model.created_at = Timestamp.now();
      model.avatar =
          "https://firebasestorage.googleapis.com/v0/b/pigu-project.appspot.com/o/users%2FdefaultUser.png?alt=media&token=74675535-a15f-4177-a4b3-282d77118c85";
      model.username =
          '(${model.mobile_region_code})${model.mobile_phone_number}';

      model.notification_enabled = true;
      model.contactlist_sync = false;
      Firestore.instance
          .collection('users')
          .document(user.uid)
          .setData(UserModel().toJson(model));
    }

    return user;
  }

  @override
  Future<FirebaseUser> handleLinkAccountGoogle(FirebaseUser _user) async {
    // final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    // final GoogleSignInAuthentication googleAuth =
    //     await googleUser.authentication;
    FirebaseUser user;

    // final AuthCredential credential = GoogleAuthProvider.getCredential(
    //   accessToken: googleAuth.accessToken,
    //   idToken: googleAuth.idToken,
    // );

    // user = (await _user.linkWithCredential(credential)).user;
    // //print"signed in " + user.displayName);
    // Firestore.instance
    //     .collection('users')
    //     .document(user.uid)
    //     .updateData({'firstName': user.displayName, 'email': user.email});
    // // var credentialResult = await _auth.signInWithCredential(credential);
    // // user.linkWithCredential(credential);
    // return user;
  }

  @override
  Future<FirebaseUser> handleGoogleSignin() async {
    // final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    // final GoogleSignInAuthentication googleAuth =
    //     await googleUser.authentication;
    FirebaseUser user;
    // final AuthCredential credential = GoogleAuthProvider.getCredential(
    //   accessToken: googleAuth.accessToken,
    //   idToken: googleAuth.idToken,
    // );
    // List<String> providers =
    //     await _auth.fetchSignInMethodsForEmail(email: googleUser.email);
    // //print'providers: $providers');
    // if (providers != null) {
    //   //print"TEM PROV  $user");
    //   user = (await _auth.signInWithCredential(credential)).user;

    //   user.linkWithCredential(credential);
    //   //print"TEM PROV  $user");
    // } else {
    //   user = (await _auth.signInWithCredential(credential)).user;
    //   //print"signed in " + user.displayName);
    //   //print"NAO TEM PROV  $user");
    // }
    // user = (await _auth.signInWithCredential(credential)).user;
    // //print"signed in " + user.displayName);
    // var credentialResult = await _auth.signInWithCredential(credential);
    // user.linkWithCredential(credential);
    return user;
  }

  @override
  Future handleSetSignout() {
    return _auth.signOut();
  }

  @override
  Future verifyNumber(String userPhone) async {
    String verifID;
    var phoneMobile = userPhone;
    //print'$phoneMobile');

    await _auth
        .verifyPhoneNumber(
      phoneNumber: phoneMobile,
      verificationCompleted: (AuthCredential authCredential) async {
        //code for signing in}).catchError((e){
        final FirebaseUser user =
            (await _auth.signInWithCredential(authCredential)).user;
        _auth.signInWithCredential(authCredential).then((AuthResult result) {
          //print'AuthResult ${result.user}');
        }).catchError((e) {
          //print'ERROR !!! $e');
        });
        // //print'verifyPhoneNumber $e}');
      },
      verificationFailed: (AuthException authException) {
        // //printauthException.message);
        //print'ERROR !!! ${authException.message}');
      },
      codeSent: (String verificationId, [int forceResendingToken]) {
        verificationId = verificationId;
        verifID = verificationId;
        // Modular.to.pushNamed('/signin-phone/signin-phone-verify');

        //print"Código enviado para " + userPhone);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        verificationId = verificationId;
        //printverificationId);
        //print"Timout");
      },
      timeout: Duration(seconds: 60),
    )
        .catchError((e) {
      //print'ERROR !!! $e');
    });
    return verifID;
  }

  @override
  Future<FirebaseUser> handleSmsSignin(
      String smsCode, String verificationId) async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId, smsCode: smsCode);

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;

    return user;
  }
}
