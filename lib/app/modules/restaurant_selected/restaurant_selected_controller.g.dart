// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_selected_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$RestaurantSelectedController
    on _RestaurantSelectedControllerBase, Store {
  final _$valueAtom = Atom(name: '_RestaurantSelectedControllerBase.value');

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

  final _$estimationAtom =
      Atom(name: '_RestaurantSelectedControllerBase.estimation');

  @override
  num get estimation {
    _$estimationAtom.reportRead();
    return super.estimation;
  }

  @override
  set estimation(num value) {
    _$estimationAtom.reportWrite(value, super.estimation, () {
      super.estimation = value;
    });
  }

  final _$sellerAtom = Atom(name: '_RestaurantSelectedControllerBase.seller');

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

  final _$queuetimeAtom =
      Atom(name: '_RestaurantSelectedControllerBase.queuetime');

  @override
  DateTime get queuetime {
    _$queuetimeAtom.reportRead();
    return super.queuetime;
  }

  @override
  set queuetime(DateTime value) {
    _$queuetimeAtom.reportWrite(value, super.queuetime, () {
      super.queuetime = value;
    });
  }

  final _$_RestaurantSelectedControllerBaseActionController =
      ActionController(name: '_RestaurantSelectedControllerBase');

  @override
  void increment() {
    final _$actionInfo = _$_RestaurantSelectedControllerBaseActionController
        .startAction(name: '_RestaurantSelectedControllerBase.increment');
    try {
      return super.increment();
    } finally {
      _$_RestaurantSelectedControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  dynamic setSeller(SellerModel sel) {
    final _$actionInfo = _$_RestaurantSelectedControllerBaseActionController
        .startAction(name: '_RestaurantSelectedControllerBase.setSeller');
    try {
      return super.setSeller(sel);
    } finally {
      _$_RestaurantSelectedControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
value: ${value},
estimation: ${estimation},
seller: ${seller},
queuetime: ${queuetime}
    ''';
  }
}
