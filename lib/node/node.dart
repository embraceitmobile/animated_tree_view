import 'dart:collection';

mixin NodeViewData<T> {
  bool isExpanded = false;

  String get key;

  String path = "";

  int get level => Node.PATH_SEPARATOR.allMatches(path).length - 1;

  String get childrenPath => "${path ?? ""}${Node.PATH_SEPARATOR}$key";

  UnmodifiableListView<Node<T>> toList();
}

abstract class Node<T> with NodeViewData<T> {
  static const PATH_SEPARATOR = ".";
  static const ROOT_KEY = "/";

  String get key;

  Object get children;

  Node<T> operator [](covariant dynamic at);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Node<T> && other.key == key;

  @override
  int get hashCode => 0;
}

extension StringUtils on String {
  List<String> get splitToNodes => this.split(Node.PATH_SEPARATOR);
}
