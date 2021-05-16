import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:tree_structure_view/listenable_node/base/i_listenable_node.dart';
import 'package:tree_structure_view/listenable_node/base/node_update_notifier.dart';
import 'package:tree_structure_view/node/base/i_node.dart';
import 'package:tree_structure_view/node/node.dart';

class ListenableNode<T> extends Node<T>
    with ChangeNotifier
    implements IListenableNode<T> {
  ListenableNode(
      {String? key, INode<T>? parent, this.shouldBubbleUpEvents = true})
      : super(key: key, parent: parent);

  factory ListenableNode.root() => ListenableNode(key: INode.ROOT_KEY);

  final bool shouldBubbleUpEvents;

  final StreamController<NodeAddEvent<T>> _addedNodes =
      StreamController<NodeAddEvent<T>>.broadcast();

  final StreamController<NodeRemoveEvent> _removedNodes =
      StreamController<NodeRemoveEvent>.broadcast();

  Node<T> get value => this;

  Stream<NodeAddEvent<T>> get addedNodes => _addedNodes.stream;

  Stream<NodeRemoveEvent> get removedNodes => _removedNodes.stream;

  Stream<NodeInsertEvent<T>> get insertedNodes => Stream.empty();

  void add(INode<T> value) {
    super.add(value);
    _notifyListeners();
    _notifyNodesAdded(NodeAddEvent([value]));
  }

  void addAll(Iterable<INode<T>> iterable) {
    super.addAll(iterable);
    _notifyListeners();
    _notifyNodesAdded(NodeAddEvent(iterable));
  }

  void remove(INode<T> value) {
    super.remove(value);
    _notifyListeners();
    _notifyNodesRemoved(NodeRemoveEvent([value]));
  }

  void removeAll(Iterable<INode<T>> iterable) {
    super.removeAll(iterable);
    _notifyListeners();
    _notifyNodesRemoved(NodeRemoveEvent(iterable));
  }

  void removeWhere(bool test(INode<T> element)) {
    final allChildren = childrenAsList.toSet();
    super.removeWhere(test);
    _notifyListeners();
    final remainingChildren = childrenAsList.toSet();
    allChildren.removeAll(remainingChildren);

    if (allChildren.isNotEmpty)
      _notifyNodesRemoved(NodeRemoveEvent(allChildren));
  }

  void clear() {
    final clearedNodes = childrenAsList;
    super.clear();
    _notifyListeners();
    _notifyNodesRemoved(NodeRemoveEvent(clearedNodes));
  }

  void dispose() {
    _addedNodes.close();
    _removedNodes.close();
    super.dispose();
  }

  void _notifyListeners() {
    notifyListeners();
    if (shouldBubbleUpEvents && !isRoot)
      (parent! as ListenableNode<T>)._notifyListeners();
  }

  void _notifyNodesAdded(NodeAddEvent<T> event) {
    if (isRoot) {
      _addedNodes.sink.add(event);
    } else {
      (parent! as ListenableNode<T>)._notifyNodesAdded(event);
    }
  }

  void _notifyNodesRemoved(NodeRemoveEvent<T> event) {
    if (isRoot) {
      _removedNodes.sink.add(event);
    } else {
      (parent! as ListenableNode<T>)._notifyNodesRemoved(event);
    }
  }
}
