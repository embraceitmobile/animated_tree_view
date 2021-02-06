import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:multi_level_list_view/exceptions/exceptions.dart';
import 'base/i_node_actions.dart';
import 'node.dart';

export 'node.dart';

class MapNode<T> with NodeViewData<T> implements Node<T>, IMapNodeActions<T> {
  final Map<String, MapNode<T>> children;
  final String key;
  String path;

  @mustCallSuper
  MapNode([String key])
      : children = <String, MapNode<T>>{},
        key = key ?? UniqueKey().toString();

  UnmodifiableListView<Node<T>> get childrenAsList =>
      UnmodifiableListView(children.values.toList(growable: false));

  @override
  void add(Node<T> value) {
    if (children.containsKey(value.key)) throw DuplicateKeyException(value.key);
    value.path = childrenPath;
    children[value.key] = value;

    if (children.isNotEmpty) {
      //TODO: handle if value has children
      // need to update the path of all the children in the hierarchy

    }
  }

  @override
  Future<void> addAsync(Node<T> value) async {
    //TODO: update this method to use computes
    return add(value);
  }

  @override
  void addAll(Iterable<Node<T>> iterable) {
    for (final node in iterable) {
      add(node);
    }
  }

  @override
  Future<void> addAllAsync(Iterable<Node<T>> iterable) async {
    //TODO: update this method to use computes
    return addAll(iterable);
  }

  @override
  void clear() {
    children.clear();
  }

  @override
  void remove(String key) {
    children.remove(key);
  }

  @override
  void removeAll(Iterable<String> keys) {
    keys.forEach((key) => children.remove(key));
  }

  @override
  void removeWhere(bool Function(Node<T> element) test) {
    children.removeWhere((key, value) => test(value));
  }

  @override
  MapNode<T> operator [](String path) => elementAt(path);

  @override
  MapNode<T> elementAt(String path) {
    var currentNode = this;
    for (final node in path.splitToNodes) {
      if (node.isEmpty) {
        return currentNode;
      } else if (node == currentNode.key) {
        continue;
      } else {
        final nextNode = currentNode.children[node];
        if (nextNode == null) throw NodeNotFoundException(path, node);
        currentNode = nextNode;
      }
    }
    return currentNode;
  }
}
