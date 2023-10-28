// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_participant_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AddParticipantController on _AddParticipantControllerBase, Store {
  final _$arrayInvitesAtom =
      Atom(name: '_AddParticipantControllerBase.arrayInvites');

  @override
  ObservableList<dynamic> get arrayInvites {
    _$arrayInvitesAtom.reportRead();
    return super.arrayInvites;
  }

  @override
  set arrayInvites(ObservableList<dynamic> value) {
    _$arrayInvitesAtom.reportWrite(value, super.arrayInvites, () {
      super.arrayInvites = value;
    });
  }

  final _$valueAtom = Atom(name: '_AddParticipantControllerBase.value');

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

  final _$tableNameAtom = Atom(name: '_AddParticipantControllerBase.tableName');

  @override
  String get tableName {
    _$tableNameAtom.reportRead();
    return super.tableName;
  }

  @override
  set tableName(String value) {
    _$tableNameAtom.reportWrite(value, super.tableName, () {
      super.tableName = value;
    });
  }

  final _$sellerAtom = Atom(name: '_AddParticipantControllerBase.seller');

  @override
  SellerModel get seller {
    _$sellerAtom.reportRead();
    return super.seller;
  }

  @override
  set seller(SellerModel value) {
    _$sellerAtom.reportWrite(value, super.seller, () {
      super.seller = value;
    });
  }

  final _$unsearchAtom = Atom(name: '_AddParticipantControllerBase.unsearch');

  @override
  bool get unsearch {
    _$unsearchAtom.reportRead();
    return super.unsearch;
  }

  @override
  set unsearch(bool value) {
    _$unsearchAtom.reportWrite(value, super.unsearch, () {
      super.unsearch = value;
    });
  }

  final _$showSearchButtonAtom =
      Atom(name: '_AddParticipantControllerBase.showSearchButton');

  @override
  bool get showSearchButton {
    _$showSearchButtonAtom.reportRead();
    return super.showSearchButton;
  }

  @override
  set showSearchButton(bool value) {
    _$showSearchButtonAtom.reportWrite(value, super.showSearchButton, () {
      super.showSearchButton = value;
    });
  }

  final _$updateTableAsyncAction =
      AsyncAction('_AddParticipantControllerBase.updateTable');

  @override
  Future updateTable(String tableID) {
    return _$updateTableAsyncAction.run(() => super.updateTable(tableID));
  }

  final _$_AddParticipantControllerBaseActionController =
      ActionController(name: '_AddParticipantControllerBase');

  @override
  dynamic setShowSearchButton(bool _showSearch) {
    final _$actionInfo = _$_AddParticipantControllerBaseActionController
        .startAction(name: '_AddParticipantControllerBase.setShowSearchButton');
    try {
      return super.setShowSearchButton(_showSearch);
    } finally {
      _$_AddParticipantControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setTableName(String name) {
    final _$actionInfo = _$_AddParticipantControllerBaseActionController
        .startAction(name: '_AddParticipantControllerBase.setTableName');
    try {
      return super.setTableName(name);
    } finally {
      _$_AddParticipantControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setUnsearch(bool _unsearch) {
    final _$actionInfo = _$_AddParticipantControllerBaseActionController
        .startAction(name: '_AddParticipantControllerBase.setUnsearch');
    try {
      return super.setUnsearch(_unsearch);
    } finally {
      _$_AddParticipantControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setArrayInvites(List<dynamic> invets) {
    final _$actionInfo = _$_AddParticipantControllerBaseActionController
        .startAction(name: '_AddParticipantControllerBase.setArrayInvites');
    try {
      return super.setArrayInvites(invets);
    } finally {
      _$_AddParticipantControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void increment() {
    final _$actionInfo = _$_AddParticipantControllerBaseActionController
        .startAction(name: '_AddParticipantControllerBase.increment');
    try {
      return super.increment();
    } finally {
      _$_AddParticipantControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
arrayInvites: ${arrayInvites},
value: ${value},
tableName: ${tableName},
seller: ${seller},
unsearch: ${unsearch},
showSearchButton: ${showSearchButton}
    ''';
  }
}
