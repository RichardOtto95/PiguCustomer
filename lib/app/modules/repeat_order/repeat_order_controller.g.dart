// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repeat_order_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$RepeatOrderController on _RepeatOrderControllerBase, Store {
  final _$valueAtom = Atom(name: '_RepeatOrderControllerBase.value');

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

  final _$addLastUserOrderAsyncAction =
      AsyncAction('_RepeatOrderControllerBase.addLastUserOrder');

  @override
  Future addLastUserOrder(
      Map<String, dynamic> cart, String groupID, String orderID) {
    return _$addLastUserOrderAsyncAction
        .run(() => super.addLastUserOrder(cart, groupID, orderID));
  }

  final _$_RepeatOrderControllerBaseActionController =
      ActionController(name: '_RepeatOrderControllerBase');

  @override
  void increment() {
    final _$actionInfo = _$_RepeatOrderControllerBaseActionController
        .startAction(name: '_RepeatOrderControllerBase.increment');
    try {
      return super.increment();
    } finally {
      _$_RepeatOrderControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
value: ${value}
    ''';
  }
}
