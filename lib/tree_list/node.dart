import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

extension NodeList<T extends _Node<T>> on List<_Node<T>> {
  Node<T> get firstNode => _populateChildrenPath(first);

  Node<T> get lastNode => _populateChildrenPath(last);

  Node<T> at(int index) => _populateChildrenPath(this[index]);

  Node<T> firstNodeWhere(bool test(T element), {T orElse()}) =>
      _populateChildrenPath(this.firstWhere((e) => test(e), orElse: orElse));

  Node<T> lastNodeWhere(bool Function(T element) test, {T Function() orElse}) =>
      _populateChildrenPath(this.lastWhere((e) => test(e), orElse: orElse));

  Node<T> _populateChildrenPath(Node<T> node) {
    if (!node.hasChildren) return node;
    if (node.children.first.path.isNotEmpty) return node;
    for (final child in node.children) {
      child.path = node.childrenPath;
    }
    return node;
  }
}

mixin Node<T extends _Node<T>> implements _Node<T> {
  static const PATH_SEPARATOR = ".";

  List<Node<T>> get children;

  /// [key] should be unique, if you are overriding it then make sure that it has a unique value
  final String key = UniqueKey().toString();

  String path = "";

  bool isExpanded = false;

  bool get hasChildren => children.isNotEmpty;

  int get level => PATH_SEPARATOR.allMatches(path).length;

  Node<T> getNodeAt(String path) {
    final nodes = path.split(PATH_SEPARATOR);

    var currentNode = this;
    for (final node in nodes) {
      currentNode = currentNode.children.firstNodeWhere((n) => n.key == node);
    }
    return currentNode;
  }

  String get childrenPath => "$path${Node.PATH_SEPARATOR}$key";

  @override
  String toString() {
    return 'Node {key: $key}, path: $path, child_count: ${children.length}';
  }
}

mixin _Node<T> {
  String get key;

  String path;

  List<_Node<T>> get children;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _Node && runtimeType == other.runtimeType && key == other.key;

  @override
  int get hashCode => key.hashCode;
}
