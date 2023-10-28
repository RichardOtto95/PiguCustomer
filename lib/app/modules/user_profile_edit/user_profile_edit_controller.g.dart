// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_edit_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UserProfileEditController on _UserProfileEditControllerBase, Store {
  final _$nameAtom = Atom(name: '_UserProfileEditControllerBase.name');

  @override
  String get name {
    _$nameAtom.reportRead();
    return super.name;
  }

  @override
  set name(String value) {
    _$nameAtom.reportWrite(value, super.name, () {
      super.name = value;
    });
  }

  final _$usernameAtom = Atom(name: '_UserProfileEditControllerBase.username');

  @override
  String get username {
    _$usernameAtom.reportRead();
    return super.username;
  }

  @override
  set username(String value) {
    _$usernameAtom.reportWrite(value, super.username, () {
      super.username = value;
    });
  }

  final _$cpfAtom = Atom(name: '_UserProfileEditControllerBase.cpf');

  @override
  String get cpf {
    _$cpfAtom.reportRead();
    return super.cpf;
  }

  @override
  set cpf(String value) {
    _$cpfAtom.reportWrite(value, super.cpf, () {
      super.cpf = value;
    });
  }

  final _$updateProfileAsyncAction =
      AsyncAction('_UserProfileEditControllerBase.updateProfile');

  @override
  Future updateProfile() {
    return _$updateProfileAsyncAction.run(() => super.updateProfile());
  }

  final _$_UserProfileEditControllerBaseActionController =
      ActionController(name: '_UserProfileEditControllerBase');

  @override
  dynamic setName(String _name) {
    final _$actionInfo = _$_UserProfileEditControllerBaseActionController
        .startAction(name: '_UserProfileEditControllerBase.setName');
    try {
      return super.setName(_name);
    } finally {
      _$_UserProfileEditControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setUserName(String _name) {
    final _$actionInfo = _$_UserProfileEditControllerBaseActionController
        .startAction(name: '_UserProfileEditControllerBase.setUserName');
    try {
      return super.setUserName(_name);
    } finally {
      _$_UserProfileEditControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setEmail(String _email) {
    final _$actionInfo = _$_UserProfileEditControllerBaseActionController
        .startAction(name: '_UserProfileEditControllerBase.setEmail');
    try {
      return super.setEmail(_email);
    } finally {
      _$_UserProfileEditControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCpf(String _cpf) {
    final _$actionInfo = _$_UserProfileEditControllerBaseActionController
        .startAction(name: '_UserProfileEditControllerBase.setCpf');
    try {
      return super.setCpf(_cpf);
    } finally {
      _$_UserProfileEditControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void increment() {
    final _$actionInfo = _$_UserProfileEditControllerBaseActionController
        .startAction(name: '_UserProfileEditControllerBase.increment');
    try {
      return super.increment();
    } finally {
      _$_UserProfileEditControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
name: ${name},
username: ${username},
cpf: ${cpf}
    ''';
  }
}
