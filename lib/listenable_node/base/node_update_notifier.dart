import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tree_structure_view/node/base/i_node.dart';

import '../../tree_structure_view.dart';

abstract class NodeUpdateNotifier<T> {
  Stream<NodeAddEvent<T>> get addedNodes;

  Stream<NodeInsertEvent<T>> get insertedNodes;

  Stream<NodeRemoveEvent> get removedNodes;

  void dispose();
}

class NodeAddEvent<T> {
  final Iterable<INode<T>> items;

  const NodeAddEvent(this.items);

  @override
  String toString() {
    return 'NodeAddEvent{items: $items}';
  }
}

class NodeRemoveEvent<T> {
  final Iterable<INode<T>> items;

  const NodeRemoveEvent(this.items);

  @override
  String toString() {
    return 'NodeRemoveEvent{keys: $items}';
  }
}

class NodeInsertEvent<T> {
  final Iterable<INode<T>> items;
  final int index;

  const NodeInsertEvent(this.items, this.index);

  @override
  String toString() {
    return 'NodeInsertEvent{items: $items, index: $index}';
  }
}
