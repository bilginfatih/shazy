// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DriverController on _DriverControllerBase, Store {
  late final _$driverActiveAtom =
      Atom(name: '_DriverControllerBase.driverActive', context: context);

  @override
  bool get driverActive {
    _$driverActiveAtom.reportRead();
    return super.driverActive;
  }

  @override
  set driverActive(bool value) {
    _$driverActiveAtom.reportWrite(value, super.driverActive, () {
      super.driverActive = value;
    });
  }

  late final _$activeAsyncAction =
      AsyncAction('_DriverControllerBase.active', context: context);

  @override
  Future<void> active(BuildContext context) {
    return _$activeAsyncAction.run(() => super.active(context));
  }

  late final _$driveInformationAsyncAction =
      AsyncAction('_DriverControllerBase.driveInformation', context: context);

  @override
  Future<void> driveInformation() {
    return _$driveInformationAsyncAction.run(() => super.driveInformation());
  }

  @override
  String toString() {
    return '''
driverActive: ${driverActive}
    ''';
  }
}
