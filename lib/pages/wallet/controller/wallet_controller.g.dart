// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$WalletController on _WalletControllerBase, Store {
  late final _$isSelectedIncomeAtom =
      Atom(name: '_WalletControllerBase.isSelectedIncome', context: context);

  @override
  bool get isSelectedIncome {
    _$isSelectedIncomeAtom.reportRead();
    return super.isSelectedIncome;
  }

  @override
  set isSelectedIncome(bool value) {
    _$isSelectedIncomeAtom.reportWrite(value, super.isSelectedIncome, () {
      super.isSelectedIncome = value;
    });
  }

  late final _$_WalletControllerBaseActionController =
      ActionController(name: '_WalletControllerBase', context: context);

  @override
  void select(bool value) {
    final _$actionInfo = _$_WalletControllerBaseActionController.startAction(
        name: '_WalletControllerBase.select');
    try {
      return super.select(value);
    } finally {
      _$_WalletControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isSelectedIncome: ${isSelectedIncome}
    ''';
  }
}