import 'dart:async';

abstract class NodeUpdateNotifier {
  Stream<NodeAddEvent> get addedNodes;

  Stream<NodeInsertEvent> get insertedNodes;

  Stream<NodeRemoveEvent> get removedNodes;

  void dispose();
}

class NodeAddEvent {
  final Iterable items;

  const NodeAddEvent(this.items);

  @override
  String toString() {
    return 'NodeAddEvent{items: $items}';
  }
}

class NodeRemoveEvent {
  final Iterable items;

  const NodeRemoveEvent(this.items);

  @override
  String toString() {
    return 'NodeRemoveEvent{keys: $items}';
  }
}

class NodeInsertEvent {
  final Iterable items;
  final int index;

  const NodeInsertEvent(this.items, this.index);

  @override
  String toString() {
    return 'NodeInsertEvent{items: $items, index: $index}';
  }
}
