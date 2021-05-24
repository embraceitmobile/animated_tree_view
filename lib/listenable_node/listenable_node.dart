import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:tree_structure_view/helpers/event_stream_controller.dart';
import 'package:tree_structure_view/helpers/exceptions.dart';
import 'package:tree_structure_view/listenable_node/base/i_listenable_node.dart';
import 'package:tree_structure_view/listenable_node/base/node_update_notifier.dart';
import 'package:tree_structure_view/node/base/i_node.dart';
import 'package:tree_structure_view/node/node.dart';

class ListenableNode<T> extends Node<T>
    with ChangeNotifier
    implements IListenableNode<T> {
  ListenableNode(
      {String? key, Node<T>? parent, this.shouldBubbleUpEvents = true})
      : super(key: key, parent: parent);

  factory ListenableNode.root() => ListenableNode(key: INode.ROOT_KEY);

  final bool shouldBubbleUpEvents;
  ListenableNode<T>? parent;

  T get value => root as T;

  ListenableNode<T> get root => super.root as ListenableNode<T>;

  List<ListenableNode<T>> get childrenAsList =>
      List<ListenableNode<T>>.from(super.childrenAsList);

  final EventStreamController<NodeAddEvent<T>> _addedNodes =
      EventStreamController();

  final EventStreamController<NodeRemoveEvent<T>> _removedNodes =
      EventStreamController();

  Stream<NodeAddEvent<T>> get addedNodes {
    if (!isRoot) throw ActionNotAllowedException.listener(this);
    return _addedNodes.stream;
  }

  Stream<NodeRemoveEvent<T>> get removedNodes {
    if (!isRoot) throw ActionNotAllowedException.listener(this);
    return _removedNodes.stream;
  }

  Stream<NodeInsertEvent<T>> get insertedNodes => Stream.empty();

  void add(Node<T> value) {
    super.add(value);
    _notifyListeners();
    _notifyNodesAdded(NodeAddEvent(List<T>.from([value])));
  }

  void addAll(Iterable<Node<T>> iterable) {
    super.addAll(iterable);
    _notifyListeners();
    _notifyNodesAdded(NodeAddEvent(List<T>.from(iterable)));
  }

  void remove(Node<T> value) {
    super.remove(value);
    _notifyListeners();
    _notifyNodesRemoved(NodeRemoveEvent(List<T>.from([value])));
  }

  void delete() {
    final nodeToRemove = this;
    super.delete();
    _notifyListeners();
    _notifyNodesRemoved(NodeRemoveEvent(List<T>.from([nodeToRemove])));
  }

  void removeAll(Iterable<Node<T>> iterable) {
    super.removeAll(iterable);
    _notifyListeners();
    _notifyNodesRemoved(NodeRemoveEvent(List<T>.from(iterable)));
  }

  void removeWhere(bool test(Node<T> element)) {
    final allChildren = childrenAsList.toSet();
    super.removeWhere(test);
    _notifyListeners();
    final remainingChildren = childrenAsList.toSet();
    allChildren.removeAll(remainingChildren);

    if (allChildren.isNotEmpty)
      _notifyNodesRemoved(NodeRemoveEvent(List<T>.from(allChildren)));
  }

  void clear() {
    final clearedNodes = childrenAsList;
    super.clear();
    _notifyListeners();
    _notifyNodesRemoved(NodeRemoveEvent(List<T>.from(clearedNodes)));
  }

  ListenableNode<T> elementAt(String path) =>
      super.elementAt(path) as ListenableNode<T>;

  ListenableNode<T> operator [](String path) => elementAt(path);

  void dispose() {
    _addedNodes.close();
    _removedNodes.close();
    super.dispose();
  }

  void _notifyListeners() {
    notifyListeners();
    if (shouldBubbleUpEvents && !isRoot) parent!._notifyListeners();
  }

  void _notifyNodesAdded(NodeAddEvent<T> event) {
    if (isRoot) {
      _addedNodes.emit(event);
    } else {
      root._notifyNodesAdded(event);
    }
  }

  void _notifyNodesRemoved(NodeRemoveEvent<T> event) {
    if (isRoot) {
      _removedNodes.emit(event);
    } else {
      root._notifyNodesRemoved(event);
    }
  }
}
