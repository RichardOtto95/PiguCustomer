// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'root_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$RootController on _RootControllerBase, Store {
  final _$selectedTrunkAtom = Atom(name: '_RootControllerBase.selectedTrunk');

  @override
  int get selectedTrunk {
    _$selectedTrunkAtom.reportRead();
    return super.selectedTrunk;
  }

  @override
  set selectedTrunk(int value) {
    _$selectedTrunkAtom.reportWrite(value, super.selectedTrunk, () {
      super.selectedTrunk = value;
    });
  }

  final _$pageOrderIndexSelectedAtom =
      Atom(name: '_RootControllerBase.pageOrderIndexSelected');

  @override
  int get pageOrderIndexSelected {
    _$pageOrderIndexSelectedAtom.reportRead();
    return super.pageOrderIndexSelected;
  }

  @override
  set pageOrderIndexSelected(int value) {
    _$pageOrderIndexSelectedAtom
        .reportWrite(value, super.pageOrderIndexSelected, () {
      super.pageOrderIndexSelected = value;
    });
  }

  final _$iconeAtom = Atom(name: '_RootControllerBase.icone');

  @override
  String get icone {
    _$iconeAtom.reportRead();
    return super.icone;
  }

  @override
  set icone(String value) {
    _$iconeAtom.reportWrite(value, super.icone, () {
      super.icone = value;
    });
  }

  final _$pageControllerAtom = Atom(name: '_RootControllerBase.pageController');

  @override
  PageController get pageController {
    _$pageControllerAtom.reportRead();
    return super.pageController;
  }

  @override
  set pageController(PageController value) {
    _$pageControllerAtom.reportWrite(value, super.pageController, () {
      super.pageController = value;
    });
  }

  final _$_RootControllerBaseActionController =
      ActionController(name: '_RootControllerBase');

  @override
  dynamic setIconData(String iconData) {
    final _$actionInfo = _$_RootControllerBaseActionController.startAction(
        name: '_RootControllerBase.setIconData');
    try {
      return super.setIconData(iconData);
    } finally {
      _$_RootControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setSelectedTrunk(int value) {
    final _$actionInfo = _$_RootControllerBaseActionController.startAction(
        name: '_RootControllerBase.setSelectedTrunk');
    try {
      return super.setSelectedTrunk(value);
    } finally {
      _$_RootControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setSelectIndexPage(int page) {
    final _$actionInfo = _$_RootControllerBaseActionController.startAction(
        name: '_RootControllerBase.setSelectIndexPage');
    try {
      return super.setSelectIndexPage(page);
    } finally {
      _$_RootControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setSelectIndexOrderPage(int page) {
    final _$actionInfo = _$_RootControllerBaseActionController.startAction(
        name: '_RootControllerBase.setSelectIndexOrderPage');
    try {
      return super.setSelectIndexOrderPage(page);
    } finally {
      _$_RootControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedTrunk: ${selectedTrunk},
pageOrderIndexSelected: ${pageOrderIndexSelected},
icone: ${icone},
pageController: ${pageController}
    ''';
  }
}
