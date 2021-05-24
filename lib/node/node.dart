import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tree_structure_view/helpers/exceptions.dart';

import 'base/i_node.dart';
import 'base/i_node_actions.dart';

export 'base/i_node.dart';

class Node<T> extends INode<T> implements INodeActions<T> {
  final Map<String, Node<T>> children;
  final String key;
  Map<String, dynamic>? meta;
  Node<T>? parent;

  @mustCallSuper
  Node({String? key, this.parent})
      : this.children = <String, Node<T>>{},
        this.key = key ?? UniqueKey().toString();

  factory Node.root() => Node(key: INode.ROOT_KEY);

  Node<T> get root => super.root as Node<T>;

  UnmodifiableListView<Node<T>> get childrenAsList =>
      UnmodifiableListView(children.values.toList(growable: false));

  void add(Node<T> value) {
    if (children.containsKey(value.key)) throw DuplicateKeyException(value.key);
    value.parent = this;
    children[value.key] = value;
  }

  void addAll(Iterable<Node<T>> iterable) {
    for (final node in iterable) {
      if (children.containsKey(node.key)) throw DuplicateKeyException(node.key);
      node.parent = this;
      children[node.key] = node;
    }
  }

  void clear() {
    children.clear();
  }

  void remove(Node<T> value) {
    children.remove(value.key);
  }

  void delete() {
    if (isRoot) throw ActionNotAllowedException.deleteRoot(this);
    (parent as Node<T>).remove(this);
  }

  void removeAll(Iterable<Node<T>> iterable) {
    for (final node in iterable) {
      children.remove(node.key);
    }
  }

  void removeWhere(bool Function(Node<T> element) test) {
    children.removeWhere((key, value) => test(value));
  }

  Node<T> operator [](String path) => elementAt(path);

  Node<T> elementAt(String path) {
    Node<T> currentNode = this;
    for (final nodeKey in path.splitToNodes) {
      if (nodeKey == currentNode.key) {
        continue;
      } else {
        final nextNode = currentNode.children[nodeKey];
        if (nextNode == null)
          throw NodeNotFoundException(parentKey: path, key: nodeKey);
        currentNode = nextNode;
      }
    }
    return currentNode;
  }

  String toString() => 'Node{children: $children, key: $key, parent: $parent}';
}
