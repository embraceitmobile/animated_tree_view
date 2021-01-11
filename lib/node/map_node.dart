import 'dart:collection';
import 'package:flutter/material.dart';
import 'base/i_node_actions.dart';
import 'node.dart';

export 'node.dart';

class MapNode<T> with NodeViewData<T> implements Node<T>, IMapNodeActions<T> {
  final Map<String, MapNode<T>> children;
  final String key;
  String path;

  @mustCallSuper
  MapNode({String key})
      : children = <String, MapNode<T>>{},
        key = key ?? UniqueKey().toString();

  UnmodifiableListView<Node<T>> toList() =>
      UnmodifiableListView(children.values.toList(growable: false));

  @override
  void add(Node<T> value) {
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
  void remove(Node<T> element) {
    children.remove(element.key);
  }

  @override
  void removeAll(Iterable<Node<T>> iterable) {
    for (final node in iterable) {
      remove(node);
    }
  }

  @override
  void removeWhere(bool Function(Node<T> element) test) {
    children.removeWhere((key, value) => test(value));
  }
}
