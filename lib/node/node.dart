import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tree_structure_view/exceptions/exceptions.dart';
import 'base/i_node_actions.dart';
import 'base/i_node.dart';

export 'base/i_node.dart';

class Node<T> with INodeViewData<T> implements INode<T>, INodeActions<T> {
  final Map<String, Node<T>> children;
  final String key;
  String path;

  @mustCallSuper
  Node([String? key])
      : children = <String, Node<T>>{},
        key = key ?? UniqueKey().toString(),
        path = "";

  factory Node.root() => Node(INode.ROOT_KEY);

  UnmodifiableListView<INode<T>> get childrenAsList =>
      UnmodifiableListView(children.values.toList(growable: false));

  void add(INode<T> value) {
    if (children.containsKey(value.key)) throw DuplicateKeyException(value.key);
    value.path = childrenPath;
    final updatedValue = _updateChildrenPaths(value as Node);
    children[value.key] = updatedValue as Node<T>;
  }

  Future<void> addAsync(INode<T> value) async {
    if (children.containsKey(value.key)) throw DuplicateKeyException(value.key);
    value.path = childrenPath;
    final updatedValue = await compute(_updateChildrenPaths, (value as Node));
    children[value.key] = updatedValue as Node<T>;
  }

  void addAll(Iterable<INode<T>> iterable) {
    for (final node in iterable) {
      add(node);
    }
  }

  Future<void> addAllAsync(Iterable<INode<T>> iterable) async {
    await Future.forEach(
        iterable, (dynamic node) async => await addAsync(node));
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
          throw NodeNotFoundException(path: path, key: nodeKey);
        currentNode = nextNode;
      }
    }
    return currentNode;
  }

  static Node _updateChildrenPaths(Node node) {
    node.children.forEach((_, childNode) {
      childNode.path = node.childrenPath;
      if (childNode.children.isNotEmpty) {
        _updateChildrenPaths(childNode);
      }
    });
    return node;
  }

  String toString() {
    return 'MapNode{children: $children, key: $key, path: $path}';
  }
}
