// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_upcoming_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HistoryUpcomingController on _HistoryUpcomingControllerBase, Store {
  late final _$isDriverSelectedAtom = Atom(
      name: '_HistoryUpcomingControllerBase.isDriverSelected',
      context: context);

  @override
  bool get isDriverSelected {
    _$isDriverSelectedAtom.reportRead();
    return super.isDriverSelected;
  }

  @override
  set isDriverSelected(bool value) {
    _$isDriverSelectedAtom.reportWrite(value, super.isDriverSelected, () {
      super.isDriverSelected = value;
    });
  }

  late final _$_HistoryUpcomingControllerBaseActionController =
      ActionController(
          name: '_HistoryUpcomingControllerBase', context: context);

  @override
  void userSelect(bool isSelected) {
    final _$actionInfo = _$_HistoryUpcomingControllerBaseActionController
        .startAction(name: '_HistoryUpcomingControllerBase.userSelect');
    try {
      return super.userSelect(isSelected);
    } finally {
      _$_HistoryUpcomingControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isDriverSelected: ${isDriverSelected}
    ''';
  }
}
