import 'package:flutter/material.dart';

extension NodeList<T extends _Node<T>> on List<_Node<T>> {
  Node<T> get firstNode => this.first.populateChildrenPath() as Node<T>;

  Node<T> get lastNode => this.last.populateChildrenPath() as Node<T>;

  Node<T> at(int index) => this[index].populateChildrenPath() as Node<T>;

  //TODO: optimize this method, it is simply getting the first element in a loop
  Node<T> firstNodeWhere(bool test(T element), {T orElse()?}) =>
      this.firstWhere((e) => test(e as T), orElse: orElse).populateChildrenPath() as Node<T>;

  //TODO: optimize this method, it is simply getting the last element in a loop
  Node<T> lastNodeWhere(bool Function(T element) test, {T Function()? orElse}) =>
      this.lastWhere((e) => test(e as T), orElse: orElse).populateChildrenPath() as Node<T>;

  int nodeIndexWhere(bool Function(T element) test, [int start = 0]) {
    final index = this.indexWhere((e) => test(e as T), start);
    this[index].populateChildrenPath();
    return index;
  }
}

class RootNode<T extends Node<T>> with Node<T> {
  final List<Node<T>> children;
  final String key;

  RootNode(this.children) : this.key = Node.ROOT_KEY;
}

mixin Node<T extends _Node<T>> implements _Node<T> {
  static const PATH_SEPARATOR = ".";
  static const ROOT_KEY = "/";

  List<Node<T>> get children;

  /// [key] should be unique, if you are overriding it then make sure that it has a unique value
  final String key = UniqueKey().toString();

  String? path = "";

  bool isExpanded = false;

  bool get hasChildren => children.isNotEmpty;

  int get level => PATH_SEPARATOR.allMatches(path!).length - 1;

  String get childrenPath => "$path${Node.PATH_SEPARATOR}$key";

  Node<T> getNodeAt(String? path) {
    assert(key != ROOT_KEY ? !path!.contains(ROOT_KEY) : true,
        "Path with ROOT_KEY = $ROOT_KEY can only be called from the root node");

    final nodes = Node.normalizePath(path).split(PATH_SEPARATOR);

    Node<T> currentNode = this;
    for (final node in nodes) {
      if (node.isEmpty) {
        return currentNode;
      } else {
        currentNode = currentNode.children.firstNodeWhere((n) => n.key == node);
      }
    }
    return currentNode;
  }

  Node<T> populateChildrenPath({bool? refresh = false}) {
    if (children.isEmpty) return this;
    if (!refresh! && children.first.path!.isNotEmpty) return this;
    for (final child in children) {
      child.path = this.childrenPath;
    }
    return this;
  }

  static String normalizePath(String? path) {
    if (path?.isEmpty ?? true) return "";
    var _path = path
        .toString()
        .replaceAll("$PATH_SEPARATOR$ROOT_KEY", "")
        .replaceAll(ROOT_KEY, "");

    if (_path.startsWith(PATH_SEPARATOR)) _path = _path.substring(1);
    return _path;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Node && key == other.key;

  @override
  int get hashCode => key.hashCode;

  @override
  String toString() {
    return 'Node {key: $key}, path: $path, child_count: ${children.length}';
  }
}

mixin _Node<T> {
  String get key;

  String? path;

  List<_Node<T>> get children;

  _Node<T> populateChildrenPath({bool? refresh});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _Node && runtimeType == other.runtimeType && key == other.key;

  @override
  int get hashCode => key.hashCode;
}
