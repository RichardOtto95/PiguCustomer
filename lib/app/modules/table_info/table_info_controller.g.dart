// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_info_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$TableInfoController on _TableInfoControllerBase, Store {
  final _$valueAtom = Atom(name: '_TableInfoControllerBase.value');

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

  final _$clickLabelAtom = Atom(name: '_TableInfoControllerBase.clickLabel');

  @override
  String get clickLabel {
    _$clickLabelAtom.reportRead();
    return super.clickLabel;
  }

  @override
  set clickLabel(String value) {
    _$clickLabelAtom.reportWrite(value, super.clickLabel, () {
      super.clickLabel = value;
    });
  }

  @override
  String toString() {
    return '''
value: ${value},
clickLabel: ${clickLabel}
    ''';
  }
}
