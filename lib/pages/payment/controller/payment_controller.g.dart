// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PaymentController on _PaymentControllerBase, Store {
  late final _$cardAtom =
      Atom(name: '_PaymentControllerBase.card', context: context);

  @override
  PaymentModel get card {
    _$cardAtom.reportRead();
    return super.card;
  }

  @override
  set card(PaymentModel value) {
    _$cardAtom.reportWrite(value, super.card, () {
      super.card = value;
    });
  }

  late final _$initAsyncAction =
      AsyncAction('_PaymentControllerBase.init', context: context);

  @override
  Future<void> init() {
    return _$initAsyncAction.run(() => super.init());
  }

  @override
  String toString() {
    return '''
card: ${card}
    ''';
  }
}
