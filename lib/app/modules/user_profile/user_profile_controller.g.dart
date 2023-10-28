// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UserProfileController on _UserProfileControllerBase, Store {
  final _$valueAtom = Atom(name: '_UserProfileControllerBase.value');

  @override
  int get value {
    _$valueAtom.reportRead();
    return super.value;
  }

  @override
  set value(int value) {
    _$valueAtom.reportWrite(value, super.value, () {
      super.value = value;
    });
  }

  final _$_UserProfileControllerBaseActionController =
      ActionController(name: '_UserProfileControllerBase');

  @override
  void increment() {
    final _$actionInfo = _$_UserProfileControllerBaseActionController
        .startAction(name: '_UserProfileControllerBase.increment');
    try {
      return super.increment();
    } finally {
      _$_UserProfileControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
value: ${value}
    ''';
  }
}
