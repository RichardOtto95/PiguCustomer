// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AuthController on _AuthControllerBase, Store {
  final _$statusAtom = Atom(name: '_AuthControllerBase.status');

  @override
  AuthStatus get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(AuthStatus value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  final _$positionAtom = Atom(name: '_AuthControllerBase.position');

  @override
  Position get position {
    _$positionAtom.reportRead();
    return super.position;
  }

  @override
  set position(Position value) {
    _$positionAtom.reportWrite(value, super.position, () {
      super.position = value;
    });
  }

  final _$userVerifyIdAtom = Atom(name: '_AuthControllerBase.userVerifyId');

  @override
  String get userVerifyId {
    _$userVerifyIdAtom.reportRead();
    return super.userVerifyId;
  }

  @override
  set userVerifyId(String value) {
    _$userVerifyIdAtom.reportWrite(value, super.userVerifyId, () {
      super.userVerifyId = value;
    });
  }

  final _$phoneMobileAtom = Atom(name: '_AuthControllerBase.phoneMobile');

  @override
  String get phoneMobile {
    _$phoneMobileAtom.reportRead();
    return super.phoneMobile;
  }

  @override
  set phoneMobile(String value) {
    _$phoneMobileAtom.reportWrite(value, super.phoneMobile, () {
      super.phoneMobile = value;
    });
  }

  final _$linkedAtom = Atom(name: '_AuthControllerBase.linked');

  @override
  bool get linked {
    _$linkedAtom.reportRead();
    return super.linked;
  }

  @override
  set linked(bool value) {
    _$linkedAtom.reportWrite(value, super.linked, () {
      super.linked = value;
    });
  }

  final _$userAtom = Atom(name: '_AuthControllerBase.user');

  @override
  FirebaseUser get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(FirebaseUser value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  final _$codeSentAtom = Atom(name: '_AuthControllerBase.codeSent');

  @override
  bool get codeSent {
    _$codeSentAtom.reportRead();
    return super.codeSent;
  }

  @override
  set codeSent(bool value) {
    _$codeSentAtom.reportWrite(value, super.codeSent, () {
      super.codeSent = value;
    });
  }

  final _$userBDAtom = Atom(name: '_AuthControllerBase.userBD');

  @override
  UserModel get userBD {
    _$userBDAtom.reportRead();
    return super.userBD;
  }

  @override
  set userBD(UserModel value) {
    _$userBDAtom.reportWrite(value, super.userBD, () {
      super.userBD = value;
    });
  }

  final _$signinWithGoogleAsyncAction =
      AsyncAction('_AuthControllerBase.signinWithGoogle');

  @override
  Future<dynamic> signinWithGoogle() {
    return _$signinWithGoogleAsyncAction.run(() => super.signinWithGoogle());
  }

  final _$linkAccountGoogleAsyncAction =
      AsyncAction('_AuthControllerBase.linkAccountGoogle');

  @override
  Future<dynamic> linkAccountGoogle() {
    return _$linkAccountGoogleAsyncAction.run(() => super.linkAccountGoogle());
  }

  final _$getUserAsyncAction = AsyncAction('_AuthControllerBase.getUser');

  @override
  Future<dynamic> getUser() {
    return _$getUserAsyncAction.run(() => super.getUser());
  }

  final _$signupAsyncAction = AsyncAction('_AuthControllerBase.signup');

  @override
  Future<dynamic> signup(UserModel user) {
    return _$signupAsyncAction.run(() => super.signup(user));
  }

  final _$siginEmailAsyncAction = AsyncAction('_AuthControllerBase.siginEmail');

  @override
  Future<dynamic> siginEmail(String email, String password) {
    return _$siginEmailAsyncAction.run(() => super.siginEmail(email, password));
  }

  final _$signoutAsyncAction = AsyncAction('_AuthControllerBase.signout');

  @override
  Future<dynamic> signout() {
    return _$signoutAsyncAction.run(() => super.signout());
  }

  final _$sentSMSAsyncAction = AsyncAction('_AuthControllerBase.sentSMS');

  @override
  Future<dynamic> sentSMS(String userPhone) {
    return _$sentSMSAsyncAction.run(() => super.sentSMS(userPhone));
  }

  final _$signinSMSAsyncAction = AsyncAction('_AuthControllerBase.signinSMS');

  @override
  Future<dynamic> signinSMS(String smsCode, String verify) {
    return _$signinSMSAsyncAction.run(() => super.signinSMS(smsCode, verify));
  }

  final _$verifyNumberAsyncAction =
      AsyncAction('_AuthControllerBase.verifyNumber');

  @override
  Future<dynamic> verifyNumber(String userPhone) {
    return _$verifyNumberAsyncAction.run(() => super.verifyNumber(userPhone));
  }

  final _$handleSmsSigninAsyncAction =
      AsyncAction('_AuthControllerBase.handleSmsSignin');

  @override
  Future<FirebaseUser> handleSmsSignin(String smsCode, String userVerifyId) {
    return _$handleSmsSigninAsyncAction
        .run(() => super.handleSmsSignin(smsCode, userVerifyId));
  }

  final _$_AuthControllerBaseActionController =
      ActionController(name: '_AuthControllerBase');

  @override
  dynamic setCodeSent(bool _valc) {
    final _$actionInfo = _$_AuthControllerBaseActionController.startAction(
        name: '_AuthControllerBase.setCodeSent');
    try {
      return super.setCodeSent(_valc);
    } finally {
      _$_AuthControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setLinked(bool _vald) {
    final _$actionInfo = _$_AuthControllerBaseActionController.startAction(
        name: '_AuthControllerBase.setLinked');
    try {
      return super.setLinked(_vald);
    } finally {
      _$_AuthControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setUser(FirebaseUser value) {
    final _$actionInfo = _$_AuthControllerBaseActionController.startAction(
        name: '_AuthControllerBase.setUser');
    try {
      return super.setUser(value);
    } finally {
      _$_AuthControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setPosition(Position pos) {
    final _$actionInfo = _$_AuthControllerBaseActionController.startAction(
        name: '_AuthControllerBase.setPosition');
    try {
      return super.setPosition(pos);
    } finally {
      _$_AuthControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
status: ${status},
position: ${position},
userVerifyId: ${userVerifyId},
phoneMobile: ${phoneMobile},
linked: ${linked},
user: ${user},
codeSent: ${codeSent},
userBD: ${userBD}
    ''';
  }
}
