import 'package:flutter/material.dart';

mixin Entry<T extends _Entry<T>> implements _Entry<T> {
  static const PATH_SEPARATOR = ".";

  List<T> get children;

  /// [key] should be unique, if you are overriding it then make sure that it has a unique value
  final String key = UniqueKey().toString();

  String entryPath = "";

  bool isExpanded = false;

  bool get hasChildren => children.isNotEmpty;

  int get level => PATH_SEPARATOR.allMatches(entryPath).length;

  @override
  String toString() {
    return 'MultiLevelEntry{key: $key}, path: $entryPath, child_count: ${children.length}';
  }
}

mixin _Entry<T> {
  String get key;

  String entryPath;

  List<T> get children;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _Entry && runtimeType == other.runtimeType && key == other.key;

  @override
  int get hashCode => key.hashCode;
}
