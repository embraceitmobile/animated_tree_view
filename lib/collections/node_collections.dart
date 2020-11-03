import 'package:flutter/material.dart';
import 'package:multi_level_list_view/multi_level_list_view.dart';

extension NodeList<T extends _Node<T>> on List<_Node<T>> {
  Node<T> get firstNode => this.first.populateChildrenPath();

  Node<T> get lastNode => this.last.populateChildrenPath();

  Node<T> at(int index) => this[index].populateChildrenPath();

  //TODO: optimize this method, it is simply getting the first element in a loop
  Node<T> firstNodeWhere(bool test(T element), {T orElse()}) =>
      this.firstWhere((e) => test(e), orElse: orElse).populateChildrenPath();

  //TODO: optimize this method, it is simply getting the last element in a loop
  Node<T> lastNodeWhere(bool Function(T element) test, {T Function() orElse}) =>
      this.lastWhere((e) => test(e), orElse: orElse).populateChildrenPath();
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
    assert(key != ROOT_KEY ? !path.contains(ROOT_KEY) : true,
        "Path with ROOT_KEY = $ROOT_KEY can only be called from the root node");

    path = path
        .replaceAll("$PATH_SEPARATOR$ROOT_KEY", "")
        .replaceAll(ROOT_KEY, "");

    if (path.startsWith(PATH_SEPARATOR)) path = path.substring(1);
    final nodes = path.split(PATH_SEPARATOR);

    var currentNode = this;
    for (final node in nodes) {
      if (node.isEmpty) {
        return currentNode.children.first;
      } else {
        currentNode = currentNode.children.firstNodeWhere((n) => n.key == node);
      }
    }
    return currentNode;
  }

  Node<T> populateChildrenPath() {
    if (children.isEmpty) return this;
    if (children.first.path.isNotEmpty) return this;
    for (final child in children) {
      child.path = this.childrenPath;
    }
    return this;
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

  _Node<T> populateChildrenPath();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _Node && runtimeType == other.runtimeType && key == other.key;

  @override
  int get hashCode => key.hashCode;
}
