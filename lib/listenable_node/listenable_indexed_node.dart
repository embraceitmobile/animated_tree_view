import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:tree_structure_view/helpers/event_stream_controller.dart';
import 'package:tree_structure_view/helpers/exceptions.dart';
import 'package:tree_structure_view/listenable_node/base/node_update_notifier.dart';
import 'package:tree_structure_view/node/base/i_node.dart';
import 'package:tree_structure_view/node/indexed_node.dart';

import 'base/i_listenable_node.dart';

class ListenableIndexedNode<T> extends IndexedNode<T>
    with ChangeNotifier
    implements IListenableNode<T> {
  ListenableIndexedNode(
      {String? key, IndexedNode<T>? parent, this.shouldBubbleUpEvents = true})
      : super(key: key, parent: parent);

  factory ListenableIndexedNode.root() =>
      ListenableIndexedNode(key: INode.ROOT_KEY);

  final bool shouldBubbleUpEvents;

  ListenableIndexedNode<T>? parent;

  T get value => root as T;

  List<ListenableIndexedNode<T>> get childrenAsList =>
      List<ListenableIndexedNode<T>>.from(super.childrenAsList);

  ListenableIndexedNode<T> get root => super.root as ListenableIndexedNode<T>;

  ListenableIndexedNode<T> get first => super.first as ListenableIndexedNode<T>;

  ListenableIndexedNode<T> get last => super.last as ListenableIndexedNode<T>;

  set first(IndexedNode<T> value) {
    this.first = value;
    _notifyListeners();
  }

  set last(IndexedNode<T> value) {
    this.last = value;
    _notifyListeners();
  }

  ListenableIndexedNode<T> firstWhere(
      bool Function(IndexedNode<T> element) test,
      {IndexedNode<T> orElse()?}) {
    return super.firstWhere(test, orElse: orElse) as ListenableIndexedNode<T>;
  }

  int indexWhere(bool Function(IndexedNode<T> element) test, [int start = 0]) {
    return super.indexWhere(test, start);
  }

  ListenableIndexedNode<T> lastWhere(bool Function(IndexedNode<T> element) test,
      {IndexedNode<T> orElse()?}) {
    return super.lastWhere(test, orElse: orElse) as ListenableIndexedNode<T>;
  }

  final EventStreamController<NodeAddEvent<T>> _addedNodes =
      EventStreamController();

  final EventStreamController<NodeInsertEvent<T>> _insertedNodes =
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

  Stream<NodeInsertEvent<T>> get insertedNodes {
    if (!isRoot) throw ActionNotAllowedException.listener(this);
    return _insertedNodes.stream;
  }

  void add(IndexedNode<T> value) {
    super.add(value);
    _notifyListeners();
    _notifyNodesAdded(NodeAddEvent(List<T>.from([value])));
  }

  void addAll(Iterable<IndexedNode<T>> iterable) {
    super.addAll(iterable);
    _notifyListeners();
    _notifyNodesAdded(NodeAddEvent(List<T>.from(iterable)));
  }

  void insert(int index, IndexedNode<T> element) {
    super.insert(index, element);
    _notifyListeners();
    _notifyNodesInserted(NodeInsertEvent<T>(List<T>.from([element]), index));
  }

  int insertAfter(IndexedNode<T> after, IndexedNode<T> element) {
    final index = super.insertAfter(after, element);
    _notifyListeners();
    _notifyNodesInserted(NodeInsertEvent<T>(List<T>.from([element]), index));
    return index;
  }

  int insertBefore(IndexedNode<T> before, IndexedNode<T> element) {
    final index = super.insertBefore(before, element);
    _notifyListeners();
    _notifyNodesInserted(NodeInsertEvent<T>(List<T>.from([element]), index));
    return index;
  }

  void insertAll(int index, Iterable<IndexedNode<T>> iterable) {
    super.insertAll(index, iterable);
    _notifyListeners();
    _notifyNodesInserted(NodeInsertEvent<T>(List<T>.from(iterable), index));
  }

  void delete() {
    final nodeToRemove = this;
    super.delete();
    _notifyListeners();
    _notifyNodesRemoved(NodeRemoveEvent(List<T>.from([nodeToRemove])));
  }

  void remove(IndexedNode<T> value) {
    super.remove(value);
    _notifyListeners();
    _notifyNodesRemoved(NodeRemoveEvent(List<T>.from([value])));
  }

  ListenableIndexedNode<T> removeAt(int index) {
    final removedNode = children.removeAt(index);
    _notifyListeners();
    _notifyNodesRemoved(NodeRemoveEvent(List<T>.from([removedNode])));
    return removedNode as ListenableIndexedNode<T>;
  }

  void removeAll(Iterable<IndexedNode<T>> iterable) {
    for (final value in iterable) {
      final index = children.indexWhere((node) => node.key == value.key);
      if (index < 0) throw NodeNotFoundException(key: key);
      children.removeAt(index);
    }

    _notifyListeners();
    _notifyNodesRemoved(NodeRemoveEvent(List<T>.from(iterable)));
  }

  void removeWhere(bool test(IndexedNode<T> element)) {
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

  ListenableIndexedNode<T> elementAt(String path) =>
      super.elementAt(path) as ListenableIndexedNode<T>;

  ListenableIndexedNode<T> at(int index) =>
      super.at(index) as ListenableIndexedNode<T>;

  ListenableIndexedNode<T> operator [](String path) => elementAt(path);

  void dispose() {
    _addedNodes.close();
    _removedNodes.close();
    _insertedNodes.close();
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

  void _notifyNodesInserted(NodeInsertEvent<T> event) {
    if (isRoot) {
      _insertedNodes.emit(event);
    } else {
      root._notifyNodesInserted(event);
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
