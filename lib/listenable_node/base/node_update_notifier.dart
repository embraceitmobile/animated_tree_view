import 'dart:async';

abstract class NodeUpdateNotifier<T> {
  Stream<NodeAddEvent<T>> get addedNodes;

  Stream<NodeInsertEvent<T>> get insertedNodes;

  Stream<NodeRemoveEvent<T>> get removedNodes;

  void dispose();
}

class NodeAddEvent<T> {
  final List<T> items;

  const NodeAddEvent(this.items);

  @override
  String toString() {
    return 'NodeAddEvent{items: $items}';
  }
}

class NodeRemoveEvent<T> {
  final List<T> items;

  const NodeRemoveEvent(this.items);

  @override
  String toString() {
    return 'NodeRemoveEvent{keys: $items}';
  }
}

class NodeInsertEvent<T> {
  final List<T> items;
  final int index;

  const NodeInsertEvent(this.items, this.index);

  @override
  String toString() {
    return 'NodeInsertEvent{items: $items, index: $index}';
  }
}
