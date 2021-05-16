import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tree_structure_view/exceptions/exceptions.dart';
import 'base/i_node_actions.dart';
import 'base/i_node.dart';

export 'base/i_node.dart';

class Node<T> extends INode<T> implements INodeActions<T> {
  final Map<String, Node<T>> children;
  final String key;
  Map<String, dynamic>? meta;
  INode<T>? parent;

  @mustCallSuper
  Node({String? key, this.parent})
      : this.children = <String, Node<T>>{},
        this.key = key ?? UniqueKey().toString();

  factory Node.root() => Node(key: INode.ROOT_KEY);

  UnmodifiableListView<INode<T>> get childrenAsList =>
      UnmodifiableListView(children.values.toList(growable: false));

  void add(INode<T> value) {
    if (children.containsKey(value.key)) throw DuplicateKeyException(value.key);
    value.parent = this;
    children[value.key] = value as Node<T>;
  }

  void addAll(Iterable<INode<T>> iterable) {
    for (final node in iterable){
      if (children.containsKey(node.key)) throw DuplicateKeyException(node.key);
      node.parent = this;
      children[node.key] = node as Node<T>;
    }
  }

  void clear() {
    children.clear();
  }

  void remove(String key) {
    children.remove(key);
  }

  void removeAll(Iterable<String> keys) {
    keys.forEach((key) => children.remove(key));
  }

  void removeWhere(bool Function(INode<T> element) test) {
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

  String toString() {
    return 'Node{children: $children, key: $key, parent: $parent}';
  }
}
