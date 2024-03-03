// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$WalletController on _WalletControllerBase, Store {
  late final _$financeListAtom =
      Atom(name: '_WalletControllerBase.financeList', context: context);

  @override
  List<FinanceModel> get financeList {
    _$financeListAtom.reportRead();
    return super.financeList;
  }

  @override
  set financeList(List<FinanceModel> value) {
    _$financeListAtom.reportWrite(value, super.financeList, () {
      super.financeList = value;
    });
  }

  late final _$incomeAtom =
      Atom(name: '_WalletControllerBase.income', context: context);

  @override
  List<dynamic> get income {
    _$incomeAtom.reportRead();
    return super.income;
  }

  @override
  set income(List<dynamic> value) {
    _$incomeAtom.reportWrite(value, super.income, () {
      super.income = value;
    });
  }

  late final _$incomeDateAtom =
      Atom(name: '_WalletControllerBase.incomeDate', context: context);

  @override
  List<dynamic> get incomeDate {
    _$incomeDateAtom.reportRead();
    return super.incomeDate;
  }

  @override
  set incomeDate(List<dynamic> value) {
    _$incomeDateAtom.reportWrite(value, super.incomeDate, () {
      super.incomeDate = value;
    });
  }

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

  late final _$outgoneAtom =
      Atom(name: '_WalletControllerBase.outgone', context: context);

  @override
  List<dynamic> get outgone {
    _$outgoneAtom.reportRead();
    return super.outgone;
  }

  @override
  set outgone(List<dynamic> value) {
    _$outgoneAtom.reportWrite(value, super.outgone, () {
      super.outgone = value;
    });
  }

  late final _$outgoneDateAtom =
      Atom(name: '_WalletControllerBase.outgoneDate', context: context);

  @override
  List<dynamic> get outgoneDate {
    _$outgoneDateAtom.reportRead();
    return super.outgoneDate;
  }

  @override
  set outgoneDate(List<dynamic> value) {
    _$outgoneDateAtom.reportWrite(value, super.outgoneDate, () {
      super.outgoneDate = value;
    });
  }

  late final _$getFinanceAsyncAction =
      AsyncAction('_WalletControllerBase.getFinance', context: context);

  @override
  Future<void> getFinance(String id) {
    return _$getFinanceAsyncAction.run(() => super.getFinance(id));
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
financeList: ${financeList},
income: ${income},
incomeDate: ${incomeDate},
isSelectedIncome: ${isSelectedIncome},
outgone: ${outgone},
outgoneDate: ${outgoneDate}
    ''';
  }
}
