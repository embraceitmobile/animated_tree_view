import 'package:animated_tree_view/src/node/base/i_node.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

/// The base class for implementing a Listenable Node. It allows for the listener
/// to observe any changes in the Node.
///
/// The [IListenableNode] also implements the [ValueListenable], so it can be
/// used with a [ValueListenableBuilder] for updating the UI whenever the node
/// is mutated.
abstract class IListenableNode<T> extends INode<T>
    implements NodeUpdateNotifier<T>, ValueListenable<T> {}

/// This class provides more granular over which updates to listen to.
abstract class NodeUpdateNotifier<T> {
  /// Listen to this [Stream] to get updates on when a Node or a collection of
  /// Nodes is added to the current node.
  /// It returns a stream of [NodeAddEvent]
  Stream<NodeAddEvent<T>> get addedNodes;

  /// Listen to this [Stream] to get updates on when a Node or a collection of
  /// Nodes is inserted in the current node.
  /// It returns a stream of [insertedNodes]
  Stream<NodeInsertEvent<T>> get insertedNodes;

  /// Listen to this [Stream] to get updates on when a Node or a collection of
  /// Nodes is removed from the current node.
  /// It returns a stream of [NodeRemoveEvent]
  Stream<NodeRemoveEvent<T>> get removedNodes;

  void dispose();
}

mixin NodeEvent<T> {}

class NodeAddEvent<T> with NodeEvent<T> {
  final List<T> items;

  const NodeAddEvent(this.items);

  @override
  String toString() {
    return 'NodeAddEvent{items: $items}';
  }
}

class NodeRemoveEvent<T> with NodeEvent<T> {
  final List<T> items;

  const NodeRemoveEvent(this.items);

  @override
  String toString() {
    return 'NodeRemoveEvent{keys: $items}';
  }
}

class NodeInsertEvent<T> with NodeEvent<T> {
  final List<T> items;
  final int index;

  const NodeInsertEvent(this.items, this.index);

  @override
  String toString() {
    return 'NodeInsertEvent{items: $items, index: $index}';
  }
}
