import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tree_structure_view/node/base/i_node.dart';

import '../../tree_structure_view.dart';

abstract class TreeUpdateNotifier<T> {
  Stream<NodeAddEvent<T>> get addedNodes;

  Stream<NodeInsertEvent<T>> get insertedNodes;

  Stream<NodeRemoveEvent> get removedNodes;

  void dispose();
}

class NodeAddEvent<T> {
  final Iterable<INode<T>> items;
  final String? path;

  const NodeAddEvent(this.items, {this.path});

  @override
  String toString() {
    return 'NodeAddEvent{items: $items, path: $path}';
  }
}

class NodeRemoveEvent {
  final Iterable<String> keys;
  final String? path;

  const NodeRemoveEvent(this.keys, {this.path});

  @override
  String toString() {
    return 'NodeRemoveEvent{keys: $keys, path: $path}';
  }
}

class NodeInsertEvent<T> {
  final Iterable<INode<T>> items;
  final String? path;
  final int index;

  const NodeInsertEvent(this.items, this.index, {this.path});

  @override
  String toString() {
    return 'NodeInsertEvent{items: $items, path: $path, index: $index}';
  }
}

