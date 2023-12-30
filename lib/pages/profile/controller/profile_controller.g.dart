// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProfileController on _ProfileControllerBase, Store {
  late final _$commentListAtom =
      Atom(name: '_ProfileControllerBase.commentList', context: context);

  @override
  List<CommentModel> get commentList {
    _$commentListAtom.reportRead();
    return super.commentList;
  }

  @override
  set commentList(List<CommentModel> value) {
    _$commentListAtom.reportWrite(value, super.commentList, () {
      super.commentList = value;
    });
  }

  late final _$descriptionAtom =
      Atom(name: '_ProfileControllerBase.description', context: context);

  @override
  String get description {
    _$descriptionAtom.reportRead();
    return super.description;
  }

  @override
  set description(String value) {
    _$descriptionAtom.reportWrite(value, super.description, () {
      super.description = value;
    });
  }

  late final _$imagePathAtom =
      Atom(name: '_ProfileControllerBase.imagePath', context: context);

  @override
  String get imagePath {
    _$imagePathAtom.reportRead();
    return super.imagePath;
  }

  @override
  set imagePath(String value) {
    _$imagePathAtom.reportWrite(value, super.imagePath, () {
      super.imagePath = value;
    });
  }

  late final _$isAnotherProfileAtom =
      Atom(name: '_ProfileControllerBase.isAnotherProfile', context: context);

  @override
  bool get isAnotherProfile {
    _$isAnotherProfileAtom.reportRead();
    return super.isAnotherProfile;
  }

  @override
  set isAnotherProfile(bool value) {
    _$isAnotherProfileAtom.reportWrite(value, super.isAnotherProfile, () {
      super.isAnotherProfile = value;
    });
  }

  late final _$lisanceVertificationAtom = Atom(
      name: '_ProfileControllerBase.lisanceVertification', context: context);

  @override
  bool get lisanceVertification {
    _$lisanceVertificationAtom.reportRead();
    return super.lisanceVertification;
  }

  @override
  set lisanceVertification(bool value) {
    _$lisanceVertificationAtom.reportWrite(value, super.lisanceVertification,
        () {
      super.lisanceVertification = value;
    });
  }

  late final _$nameAtom =
      Atom(name: '_ProfileControllerBase.name', context: context);

  @override
  String get name {
    _$nameAtom.reportRead();
    return super.name;
  }

  @override
  set name(String value) {
    _$nameAtom.reportWrite(value, super.name, () {
      super.name = value;
    });
  }

  late final _$reviewsAtom =
      Atom(name: '_ProfileControllerBase.reviews', context: context);

  @override
  String get reviews {
    _$reviewsAtom.reportRead();
    return super.reviews;
  }

  @override
  set reviews(String value) {
    _$reviewsAtom.reportWrite(value, super.reviews, () {
      super.reviews = value;
    });
  }

  late final _$starAtom =
      Atom(name: '_ProfileControllerBase.star', context: context);

  @override
  String get star {
    _$starAtom.reportRead();
    return super.star;
  }

  @override
  set star(String value) {
    _$starAtom.reportWrite(value, super.star, () {
      super.star = value;
    });
  }

  late final _$initAsyncAction =
      AsyncAction('_ProfileControllerBase.init', context: context);

  @override
  Future<void> init({String? id}) {
    return _$initAsyncAction.run(() => super.init(id: id));
  }

  @override
  String toString() {
    return '''
commentList: ${commentList},
description: ${description},
imagePath: ${imagePath},
isAnotherProfile: ${isAnotherProfile},
lisanceVertification: ${lisanceVertification},
name: ${name},
reviews: ${reviews},
star: ${star}
    ''';
  }
}
