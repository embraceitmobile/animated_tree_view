import 'package:flutter/material.dart';

class TreeNode<T extends Node<T>> with Node<T> {
  final List<Node<T>> children;

  TreeNode(this.children);
}

extension NodeList<T extends _Node<T>> on List<_Node<T>> {
  Node<T> get firstNode => _populatePath(first);

  Node<T> get lastNode => _populatePath(last);

  Node<T> at(int index) => _populatePath(this[index]);

  Node<T> firstNodeWhere(bool Function(T element) test,
          {T Function() orElse}) =>
      _populatePath(this.firstWhere(test, orElse: orElse));

  Node<T> _populatePath(Node<T> node) {
    if (node.children.isEmpty) return node;
    if (node.children.first.path.isNotEmpty) return node;
    for (final child in node.children) {
      child.path = "${node.path}.${node.key}";
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
      currentNode = currentNode.children.firstWhere((n) => n.key == node);
    }
    return currentNode;
  }

  @override
  String toString() {
    return 'MultiLevelEntry{key: $key}, path: $path, child_count: ${children.length}';
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
